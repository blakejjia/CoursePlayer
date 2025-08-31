import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

/// Audio handler that properly integrates with audio_service and just_audio
/// This ensures both system UI (notifications, Android Auto) and in-app controls work together
Future<MyAudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.blake.courser.audio',
      androidNotificationChannelName: 'Courser Audio Playback',
      androidNotificationChannelDescription:
          'Audio playback controls for Courser',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
      androidNotificationClickStartsActivity: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  // Keep a local queue to derive current media item
  List<MediaItem> _queue = const [];

  // Subscriptions to cancel on dispose
  StreamSubscription? _stateSub;
  StreamSubscription? _indexSub;
  StreamSubscription? _playerStateSub;

  MyAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    // Wire up the audio player state changes to the audio service
    _wirePlaybackState();
    _wireCurrentMediaItem();
    _wirePlayerStateToAudioService();
  }

  void _wirePlayerStateToAudioService() {
    // Listen to player state changes and update audio service accordingly
    _playerStateSub = _player.playerStateStream.listen((playerState) {
      // Update the audio service playback state when player state changes
      _updatePlaybackState();
    });
  }

  void _wirePlaybackState() {
    // Update playback state on relevant changes
    _stateSub = Rx.combineLatest7<PlayerState, Duration, Duration, double, int?,
        LoopMode, bool, void>(
      _player.playerStateStream,
      _player.positionStream,
      _player.bufferedPositionStream,
      _player.speedStream,
      _player.currentIndexStream,
      _player.loopModeStream,
      _player.shuffleModeEnabledStream,
      (playerState, position, buffered, speed, currentIndex, loopMode,
          shuffleOn) {
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

        // Update the inherited playbackState BehaviorSubject
        playbackState.add(state);
      },
    ).listen((_) {});
  }

  void _wireCurrentMediaItem() {
    int lastIndex = 0;
    _indexSub = _player.currentIndexStream.listen((idx) {
      lastIndex = idx ?? lastIndex;
      MediaItem? currentItem;
      if (_queue.isEmpty) {
        currentItem = null;
      } else {
        final i = (idx ?? lastIndex).clamp(0, _queue.length - 1);
        currentItem = _queue[i];
      }

      // Update the inherited mediaItem BehaviorSubject
      mediaItem.add(currentItem);
    });
  }

  void _updatePlaybackState() {
    // This method can be called to manually trigger a playback state update
    // The actual state update is handled by _wirePlaybackState
  }

  // BaseAudioHandler overrides for system UI controls
  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  // Custom methods for your app
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

  @override
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

    // Build a playlist with tags so audio_service can show metadata
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

    // Update the queue in audio service for system UI
    queue.add(_queue);

    await _player.play();
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  // Android Auto browsing support
  @override
  Future<List<MediaItem>> getChildren(String parentMediaId,
      [Map<String, dynamic>? options]) async {
    // Return current queue for Android Auto browsing
    // This allows Android Auto to show the current playlist
    return _queue;
  }

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    // Find the media item with matching ID and play it
    final index = _queue.indexWhere((item) => item.id == mediaId);
    if (index != -1) {
      await _player.seek(Duration.zero, index: index);
      await _player.play();
    }
  }

  /// Dispose resources to prevent duplicate players/streams lingering.
  Future<void> dispose() async {
    await _stateSub?.cancel();
    await _indexSub?.cancel();
    await _playerStateSub?.cancel();
    await _player.dispose();
  }
}
