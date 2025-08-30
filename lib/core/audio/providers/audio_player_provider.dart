import 'dart:async';
export 'audio_player_state.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/album/providers/album_provider.dart';
// import 'package:async/async.dart';

import 'package:lemon/core/data/json/models/models.dart';
import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:lemon/main.dart';
import '../audio_controller.dart';
import 'audio_handler_provider.dart';

import 'audio_player_state.dart';

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState>
    with WidgetsBindingObserver {
  final Ref ref;
  late final MyAudioHandler _audioHandler;
  StreamSubscription<MediaItem?>? _mediaItemSub;
  StreamSubscription<PlaybackState>? _playbackSub;
  MediaItem? _lastMediaItem;
  PlaybackState _lastPlayback = PlaybackState();
  bool _initialized = false;
  Timer? _progressSaveTimer;
  static const Duration _progressSaveInterval = Duration(seconds: 10);
  DateTime _lastProgressSave = DateTime.now();

  AudioPlayerNotifier(this.ref) : super(AudioPlayerInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {
    try {
      final audioHandlerAsync = ref.read(audioHandlerFutureProvider.future);
      _audioHandler = await audioHandlerAsync;
      _initialized = true;

      // Bridge audio service streams into state updates (combine manually)
      _mediaItemSub = _audioHandler.mediaItem.listen((mi) {
        _lastMediaItem = mi;
        _onUpdateState(mi, _lastPlayback);
      });
      _playbackSub = _audioHandler.playbackState.listen((ps) {
        _lastPlayback = ps;
        _onUpdateState(_lastMediaItem, ps);
      });

      // initialize default playback speed
      final settings = ref.read(settingsProvider);
      final defaultPlaybackRate = settings.defaultPlaybackSpeed;
      setSpeed(defaultPlaybackRate);

      // Start periodic progress saving
      _startProgressSaveTimer();
    } catch (e) {
      // Handle initialization error
      debugPrint('Error initializing audio handler: $e');
    }
  }

  void _onUpdateState(MediaItem? mediaItem, PlaybackState playbackState) {
    final current = state;
    if (current is AudioPlayerIdeal) {
      state = current.copyWith(
        mediaItem: mediaItem,
        playbackState: playbackState,
      );
      if (playbackState.playing && mediaItem != null) {
        // update song progress only if significant time has passed to avoid excessive writes
        final now = DateTime.now();
        if (now.difference(_lastProgressSave) > const Duration(seconds: 5)) {
          _saveCurrentProgress();
          _lastProgressSave = now;
        }
        // update latest played
        ref.read(albumProvider.notifier).updateHistory(
              LatestPlayed(current.album, int.parse(mediaItem.id)),
            );
      }
    }
  }

  /// Start a timer that periodically saves progress
  void _startProgressSaveTimer() {
    _progressSaveTimer?.cancel();
    _progressSaveTimer = Timer.periodic(_progressSaveInterval, (_) {
      _saveCurrentProgress();
    });
  }

  /// Stop the progress save timer
  void _stopProgressSaveTimer() {
    _progressSaveTimer?.cancel();
    _progressSaveTimer = null;
  }

  /// Save current playback progress to JSON
  Future<void> _saveCurrentProgress() async {
    if (!_initialized) return;

    final current = state;
    if (current is AudioPlayerIdeal && _lastMediaItem != null) {
      try {
        // Save song progress
        await ref.read(songRepositoryProvider).updateSongProgress(
              int.parse(_lastMediaItem!.id),
              _lastPlayback.position.inSeconds,
            );

        // Save album's last played song
        await ref.read(albumRepositoryProvider).updateLastPlayedSongWithId(
              int.parse(_lastMediaItem!.album!),
              int.parse(_lastMediaItem!.id),
            );

        debugPrint(
            'Progress saved: ${_lastPlayback.position.inSeconds}s for song ${_lastMediaItem!.id}');
      } catch (e) {
        debugPrint('Error saving progress: $e');
      }
    }
  }

  /// App lifecycle callback - when app goes to background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // App is going to background or being killed
        _saveCurrentProgress();
        _stopProgressSaveTimer();
        break;
      case AppLifecycleState.resumed:
        // App is coming back to foreground
        if (_initialized) {
          _startProgressSaveTimer();
        }
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., during phone calls)
        _saveCurrentProgress();
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        _saveCurrentProgress();
        break;
    }
  }

  Future<void> setSpeed(double currentSpeed) async {
    if (!_initialized) return;
    final speedOptions = <double>[1.0, 1.5, 1.7, 1.8, 2.0];
    final currentIndex = speedOptions.indexOf(currentSpeed);
    final proposed = speedOptions[(currentIndex + 1) % speedOptions.length];
    await _audioHandler.setSpeed(proposed);
  }

  Future<void> finished() async {
    if (!_initialized) return;
    await _audioHandler.skipToNext();
  }

  Future<void> seekTo(Duration position) async {
    if (!_initialized) return;
    await _audioHandler.seek(position);

    // Save progress after seeking since user changed position
    await _saveCurrentProgress();
  }

  Future<void> next() async {
    if (!_initialized) return;
    await _audioHandler.skipToNext();
  }

  Future<void> previous() async {
    if (!_initialized) return;
    await _audioHandler.skipToPrevious();
  }

  Future<void> rewind() async {
    if (!_initialized) return;
    await _audioHandler.rewind();
  }

  Future<void> locateAudio(Album album, int songId,
      {List<Song>? buffer}) async {
    if (!_initialized) return;
    List<Song>? songs = buffer ??
        await ref.read(songRepositoryProvider).getSongsByAlbumId(album.id);
    final index = songs!.indexWhere((s) => s.id == songId);
    songs = songs.sublist(index);
    final position = songs[0].playedInSecond;

    // set an ideal baseline state so UI can render quickly
    state =
        AudioPlayerIdeal(MediaItem(id: '', title: ''), PlaybackState(), album);

    await _audioHandler.locateAudio(
      songs
          .whereType<Song>()
          .map((song) => MediaItem(
                id: song.id.toString(),
                title: song.title,
                album: "${song.album}",
                displayDescription: song.path,
                artist: song.artist,
                genre: null,
                duration: Duration(seconds: song.length),
              ))
          .cast<MediaItem>()
          .toList(),
      songs.map((song) => song.path).toList().cast<String>(),
      0,
      position,
    );
  }

  Future<void> toggleShuffle() async {
    if (!_initialized) return;
    final current = state;
    if (current is! AudioPlayerIdeal) return;
    var mode = current.playbackState.shuffleMode;
    mode = mode == AudioServiceShuffleMode.none
        ? AudioServiceShuffleMode.all
        : AudioServiceShuffleMode.none;
    await _audioHandler.setShuffleMode(mode);
  }

  Future<void> play() async {
    if (!_initialized) return;
    await _audioHandler.play();
  }

  Future<void> pause() async {
    if (!_initialized) return;
    await _audioHandler.pause();

    // Always save progress when user manually pauses
    await _saveCurrentProgress();

    // refresh providers
    ref.read(songListProvider.notifier).refreshSongs();
    ref.read(albumProvider.notifier).load();
  }

  /// Manually save current progress - useful for explicit save calls
  Future<void> saveProgress() async {
    await _saveCurrentProgress();
  }

  @override
  void dispose() {
    // Save final progress before disposing
    _saveCurrentProgress();

    // Clean up subscriptions and timers
    _mediaItemSub?.cancel();
    _playbackSub?.cancel();
    _stopProgressSaveTimer();

    // Remove app lifecycle observer
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier(ref);
});
