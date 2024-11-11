part of 'audio_player_bloc.dart';

class AudioPlayerState {
  final MediaItem mediaItem;
  final PlaybackState playbackState;

  AudioPlayerState(this.mediaItem, this.playbackState);

  copyWith({
    MediaItem? mediaItem,
    PlaybackState? playbackState,
  }) =>
      AudioPlayerState(
        mediaItem ?? this.mediaItem,
        playbackState ?? this.playbackState,
      );
}
