import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

Future<MyAudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      rewindInterval: Duration(seconds: 10),
      fastForwardInterval: Duration(seconds: 10),
      androidNotificationChannelId: 'com.blake.course_player.audio',
      androidNotificationChannelName: 'course player',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      // TODO: androidNotificationIcon:
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForMediaItemChanges();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.positionStream.listen((_) async {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (_player.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: _player.playbackEvent.currentIndex,
      ));
    });
  }

  void _listenForMediaItemChanges() {
    int bufferedIndex = 0;
    _player.currentIndexStream.listen((int? index) {
      bufferedIndex = index ?? bufferedIndex;
    });
    Rx.combineLatest2<int?, List<MediaItem>, MediaItem?>(
      _player.currentIndexStream,
      queue,
      (index, queueList) {
        if (queueList.isEmpty) return null;
        return queueList[bufferedIndex];
      },
    ).listen((currentMediaItem) {
      mediaItem.add(currentMediaItem);
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> rewind() async {
    final currentPosition = _player.position;
    final rewindPosition = currentPosition - const Duration(seconds: 10);
    await _player
        .seek(rewindPosition >= Duration.zero ? rewindPosition : Duration.zero);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      _player.setShuffleModeEnabled(true);
    }
  }

  Future<void> locateAudio(List<MediaItem> mediaItems, List<String> paths,
      int? index, int? position) async {
    queue.add(mediaItems);
    final playlist = ConcatenatingAudioSource(
      children: paths.map((path) => AudioSource.file(path)).toList(),
    );

    await _player.setAudioSource(playlist);
    await _player.seek(Duration(seconds: position ?? 0), index: index ?? 0);
    await _player.play();
  }

  @override
  Future<void> setSpeed(double speed) async {
    _player.setSpeed(speed);
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
