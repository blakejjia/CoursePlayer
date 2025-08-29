import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:async/async.dart';

/// Initialize our audio controller (no background isolate needed).
Future<MyAudioHandler> initAudioService() async {
  return MyAudioHandler();
}

/// A lightweight facade over just_audio that exposes audio_service-like
/// streams so the rest of the app can remain unchanged, while
/// just_audio_background handles Android Auto/CarPlay integration.
class MyAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  // State streams compatible with existing UI
  final _mediaItemController = StreamController<MediaItem?>.broadcast();
  final _playbackStateController = StreamController<PlaybackState>.broadcast();

  // Keep a local queue to derive current media item
  List<MediaItem> _queue = const [];

  Stream<MediaItem?> get mediaItem => _mediaItemController.stream;
  Stream<PlaybackState> get playbackState => _playbackStateController.stream;

  MyAudioHandler() {
    _wirePlaybackState();
    _wireCurrentMediaItem();
  }

  void _wirePlaybackState() {
    // Update playback state on relevant changes
    StreamZip([
      _player.playerStateStream,
      _player.positionStream,
      _player.bufferedPositionStream,
      _player.speedStream,
      _player.currentIndexStream,
      _player.loopModeStream,
      _player.shuffleModeEnabledStream,
    ]).listen((values) {
      final playerState = values[0] as PlayerState;
      final position = values[1] as Duration;
      final buffered = values[2] as Duration;
      final speed = values[3] as double;
      final currentIndex = values[4] as int?;
      final loopMode = values[5] as LoopMode;
      final shuffleOn = values[6] as bool;

      final processing = () {
        switch (playerState.processingState) {
          case ProcessingState.idle:
            return AudioProcessingState.idle;
          case ProcessingState.loading:
            return AudioProcessingState.loading;
          case ProcessingState.buffering:
            return AudioProcessingState.buffering;
          case ProcessingState.ready:
            return AudioProcessingState.ready;
          case ProcessingState.completed:
            return AudioProcessingState.completed;
        }
      }();

      final repeatMode = () {
        switch (loopMode) {
          case LoopMode.off:
            return AudioServiceRepeatMode.none;
          case LoopMode.one:
            return AudioServiceRepeatMode.one;
          case LoopMode.all:
            return AudioServiceRepeatMode.all;
        }
      }();

      final shuffleMode = shuffleOn
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none;

      final state = PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          playerState.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: const [0, 1, 3],
        processingState: processing,
        repeatMode: repeatMode,
        shuffleMode: shuffleMode,
        playing: playerState.playing,
        updatePosition: position,
        bufferedPosition: buffered,
        speed: speed,
        queueIndex: currentIndex,
      );
      _playbackStateController.add(state);
    });
  }

  void _wireCurrentMediaItem() {
    int lastIndex = 0;
    _player.currentIndexStream.listen((idx) {
      lastIndex = idx ?? lastIndex;
      if (_queue.isEmpty) {
        _mediaItemController.add(null);
      } else {
        final i = (idx ?? lastIndex).clamp(0, _queue.length - 1);
        _mediaItemController.add(_queue[i]);
      }
    });
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> skipToNext() => _player.seekToNext();
  Future<void> skipToPrevious() => _player.seekToPrevious();

  Future<void> rewind() async {
    final currentPosition = _player.position;
    final rewindPosition = currentPosition - const Duration(seconds: 10);
    await _player
        .seek(rewindPosition >= Duration.zero ? rewindPosition : Duration.zero);
  }

  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        await _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      await _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      await _player.setShuffleModeEnabled(true);
    }
  }

  Future<void> locateAudio(
    List<MediaItem> mediaItems,
    List<String> paths,
    int? index,
    int? position,
  ) async {
    // Keep our current queue for UI and mediaItem stream
    _queue = mediaItems;

    // Build a playlist with tags so just_audio_background can show metadata
    final children = <AudioSource>[];
    final count = mediaItems.length;
    for (var i = 0; i < count && i < paths.length; i++) {
      children.add(
        AudioSource.uri(
          Uri.file(paths[i]),
          tag: mediaItems[i],
        ),
      );
    }
    final playlist = ConcatenatingAudioSource(children: children);

    await _player.setAudioSource(playlist);
    await _player.seek(Duration(seconds: position ?? 0), index: index ?? 0);
    await _player.play();
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  Future<void> stop() async {
    await _player.stop();
  }
}
