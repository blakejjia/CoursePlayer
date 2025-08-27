import 'package:audio_service/audio_service.dart';
import 'package:lemon/core/backEnd/json/models/models.dart';

/// Base type for audio player state
class AudioPlayerState {}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioPlayerIdeal extends AudioPlayerState {
  /// Current playing media item
  final MediaItem mediaItem;

  /// Current playback state
  final PlaybackState playbackState;

  /// Current album (playlist) context
  final Album album;

  AudioPlayerIdeal(this.mediaItem, this.playbackState, this.album);

  AudioPlayerIdeal copyWith({
    MediaItem? mediaItem,
    PlaybackState? playbackState,
    Album? album,
  }) =>
      AudioPlayerIdeal(
        mediaItem ?? this.mediaItem,
        playbackState ?? this.playbackState,
        album ?? this.album,
      );
}
