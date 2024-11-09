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
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream
        .debounceTime(Duration(milliseconds: 100))
        .listen((PlaybackEvent event) {
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
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final currentItem = playlist[index];
      mediaItem.add(currentItem);
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;

      final items = sequence
          .where((source) => source.tag != null) // 过滤掉 tag 为 null 的项
          .map((source) => source.tag as MediaItem)
          .toList();

      queue.add(items);
    });
  }

  // @override
  // Future<void> addQueueItems(List<MediaItem> mediaItems) async {
  //   // manage Just Audio
  //   final audioSource = mediaItems.map(_createAudioSource);
  //   _playlist.addAll(audioSource.toList());
  //
  //   // notify system
  //   final newQueue = queue.value..addAll(mediaItems);
  //   queue.add(newQueue);
  // }
  //
  // @override
  // Future<void> addQueueItem(MediaItem mediaItem) async {
  //   // manage Just Audio
  //   final audioSource = _createAudioSource(mediaItem);
  //   _playlist.add(audioSource);
  //
  //   // notify system
  //   final newQueue = queue.value..add(mediaItem);
  //   queue.add(newQueue);
  // }

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

  Future<void> locateAudio(List<String> paths, int index) async {
    final playlist = ConcatenatingAudioSource(
      children: paths.map((path) => AudioSource.file(path)).toList(),
    );

    await _player.setAudioSource(playlist);

    await _player.seek(Duration.zero, index: index);
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
