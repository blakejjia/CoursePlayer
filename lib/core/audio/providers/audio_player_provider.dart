import 'dart:async';
export 'audio_player_state.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import 'package:lemon/core/backEnd/json/models.dart';
// Repositories are accessed via Riverpod providers in main.dart
import 'package:lemon/features/album/providers/album_provider.dart';
import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:lemon/main.dart';
import '../audio_service.dart';

import 'audio_player_state.dart';

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  late final MyAudioHandler _audioHandler;
  StreamSubscription? _playerInfoSub;

  AudioPlayerNotifier() : super(AudioPlayerInitial()) {
    _init();
  }

  Future<void> _init() async {
    _audioHandler = await providerContainer.read(audioHandlerProvider.future);

    // Bridge audio service streams into state updates
    _playerInfoSub = CombineLatestStream.combine2(
      _audioHandler.playbackState,
      _audioHandler.mediaItem,
      (playbackState, mediaItem) => (mediaItem, playbackState),
    ).listen((tuple) {
      final mediaItem = tuple.$1;
      final playbackState = tuple.$2;
      _onUpdateState(mediaItem, playbackState);
    });

    // initialize default playback speed
    final settings = providerContainer.read(settingsProvider);
    final defaultPlaybackRate = settings.defaultPlaybackSpeed;
    setSpeed(defaultPlaybackRate);
  }

  void _onUpdateState(MediaItem? mediaItem, PlaybackState playbackState) {
    final current = state;
    if (current is AudioPlayerIdeal) {
      state = current.copyWith(
        mediaItem: mediaItem,
        playbackState: playbackState,
      );
      if (playbackState.playing && mediaItem != null) {
        // update song progress
        providerContainer.read(songRepositoryProvider).updateSongProgress(
              int.parse(mediaItem.id),
              playbackState.position.inSeconds,
            );
        // update latest played
        providerContainer.read(albumProvider.notifier).updateHistory(
              LatestPlayed(current.album, int.parse(mediaItem.id)),
            );
      }
    }
  }

  Future<void> setSpeed(double currentSpeed) async {
    final speedOptions = <double>[1.0, 1.5, 1.7, 1.8, 2.0];
    final currentIndex = speedOptions.indexOf(currentSpeed);
    final proposed = speedOptions[(currentIndex + 1) % speedOptions.length];
    await _audioHandler.setSpeed(proposed);
  }

  Future<void> finished() async {
    await _audioHandler.skipToNext();
  }

  Future<void> seekTo(Duration position) async {
    await _audioHandler.seek(position);
  }

  Future<void> next() async {
    await _audioHandler.skipToNext();
  }

  Future<void> previous() async {
    await _audioHandler.skipToPrevious();
  }

  Future<void> rewind() async {
    await _audioHandler.rewind();
  }

  Future<void> locateAudio(Album album, int songId,
      {List<Song>? buffer}) async {
    List<Song>? songs = buffer ??
        await providerContainer
            .read(songRepositoryProvider)
            .getSongsByAlbumId(album.id);
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
    final current = state;
    if (current is! AudioPlayerIdeal) return;
    var mode = current.playbackState.shuffleMode;
    mode = mode == AudioServiceShuffleMode.none
        ? AudioServiceShuffleMode.all
        : AudioServiceShuffleMode.none;
    await _audioHandler.setShuffleMode(mode);
  }

  Future<void> play() async => _audioHandler.play();

  Future<void> pause() async {
    await _audioHandler.pause();
    if (state is AudioPlayerIdeal) {
      final s = state as AudioPlayerIdeal;
      await providerContainer
          .read(albumRepositoryProvider)
          .updateLastPlayedSongWithId(
            int.parse(s.mediaItem.album!),
            int.parse(s.mediaItem.id),
          );
    }
    // refresh providers
    providerContainer.read(songListProvider.notifier).refreshSongs();
    providerContainer.read(albumProvider.notifier).load();
  }

  @override
  void dispose() {
    _playerInfoSub?.cancel();
    super.dispose();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});
