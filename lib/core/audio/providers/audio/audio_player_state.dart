import 'package:audio_service/audio_service.dart';

/// Base type for audio player state
class AudioPlayerState {}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioPlayerIdeal extends AudioPlayerState {
  /// Current playing media item
  final MediaItem mediaItem;

  /// Current playback state
  final PlaybackState playbackState;

  AudioPlayerIdeal(this.mediaItem, this.playbackState);

  AudioPlayerIdeal copyWith({
    MediaItem? mediaItem,
    PlaybackState? playbackState,
  }) =>
      AudioPlayerIdeal(
        mediaItem ?? this.mediaItem,
        playbackState ?? this.playbackState,
      );
}
