import 'dart:async';
export 'audio_player_state.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/albums/providers/album_provider.dart';
// import 'package:async/async.dart';

import 'package:lemon/core/data/models/models.dart';
import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:lemon/main.dart';
import 'audio_controller.dart';
import 'audio_handler_provider.dart';
import '../porgress/progress_update_provider.dart';

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
  Timer? _uiRefreshTimer;
  static const Duration _progressSaveInterval = Duration(seconds: 10);
  static const Duration _uiRefreshInterval = Duration(seconds: 30);
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

      // Start periodic UI refresh (less frequent)
      _startUIRefreshTimer();
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
        ref.read(albumsProvider.notifier).updateHistory(current.album.id);
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

  /// Start a timer that periodically refreshes UI to show updated progress
  void _startUIRefreshTimer() {
    _uiRefreshTimer?.cancel();
    _uiRefreshTimer = Timer.periodic(_uiRefreshInterval, (_) {
      // Only refresh if audio is playing
      final current = state;
      if (current is AudioPlayerIdeal && _lastPlayback.playing) {
        ref.read(songListProvider.notifier).refreshSongs();
        debugPrint('UI refreshed to show updated progress');
      }
    });
  }

  /// Stop the UI refresh timer
  void _stopUIRefreshTimer() {
    _uiRefreshTimer?.cancel();
    _uiRefreshTimer = null;
  }

  /// Save current playback progress to JSON
  Future<void> _saveCurrentProgress({bool refreshUI = false}) async {
    if (!_initialized) return;

    final current = state;
    if (current is AudioPlayerIdeal && _lastMediaItem != null) {
      try {
        final songId = int.parse(_lastMediaItem!.id);
        final progress = _lastPlayback.position.inSeconds;

        // Save song progress
        await ref.read(albumRepositoryProvider).updateSongProgress(
              current.album.id,
              songId.toString(),
              progress,
            );

        // Update in-memory progress for UI
        ref
            .read(currentSongProgressProvider.notifier)
            .updateProgress(songId, progress);

        // Refresh UI if requested (for user-initiated saves)
        if (refreshUI) {
          ref.read(songListProvider.notifier).refreshSongs();
          ref.read(albumsProvider.notifier).load();
        }

        debugPrint('Progress saved: ${progress}s for song $songId');
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
        _stopUIRefreshTimer();
        break;
      case AppLifecycleState.resumed:
        // App is coming back to foreground
        if (_initialized) {
          _startProgressSaveTimer();
          _startUIRefreshTimer();
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

    // Save progress after seeking since user changed position and refresh UI
    await _saveCurrentProgress(refreshUI: true);
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

  Future<void> locateAudio({required Album album, String? songId}) async {
    debugPrint('Locating audio: album=${album.title}, songId=$songId');
    // init needed variables
    final buffer = album.songs;
    if (!_initialized || buffer.isEmpty) return;
    int index = 0;
    if (songId != null) {
      index = buffer.indexWhere((s) => s.id == songId);
    }
    final selectedSong = buffer[index];
    final position = selectedSong.playedInSecond;

    // Locate and play
    await _audioHandler.playAudio(
      buffer
          .map((song) => MediaItem(
                id: song.id,
                title: song.title,
                album: album.title, // Use album title instead of ID
                displayTitle: song.title,
                displaySubtitle: song.artist,
                displayDescription: album.title,
                artist: song.artist,
                duration: Duration(seconds: song.length),
                // TODO: add artwork here
                // artUri: Uri.parse('asset:///assets/default_cover.jpeg'),
                extras: {
                  'albumId': album.id,
                  'songPath': song.path,
                  'albumArtist': album.author,
                },
              ))
          .toList(),
      buffer.map((song) => song.path).toList(),
      index: index, // Pass the actual index of the selected song
      position: position,
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

    // Always save progress when user manually pauses and refresh UI
    await _saveCurrentProgress(refreshUI: true);
  }

  /// Manually save current progress - useful for explicit save calls
  Future<void> saveProgress() async {
    await _saveCurrentProgress(refreshUI: true);
  }

  @override
  void dispose() {
    // Save final progress before disposing
    _saveCurrentProgress();

    // Clean up subscriptions and timers
    _mediaItemSub?.cancel();
    _playbackSub?.cancel();
    _stopProgressSaveTimer();
    _stopUIRefreshTimer();

    // Remove app lifecycle observer
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier(ref);
});
