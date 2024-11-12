part of 'audio_player_bloc.dart';

class AudioPlayerState {
  final MediaItem mediaItem;
  final PlaybackState playbackState;
  final int currentPlaylistId;

  AudioPlayerState(this.mediaItem, this.playbackState, this.currentPlaylistId);

  copyWith(
          {MediaItem? mediaItem,
          PlaybackState? playbackState,
          int? currentPlaylist}) =>
      AudioPlayerState(
          mediaItem ?? this.mediaItem,
          playbackState ?? this.playbackState,
          currentPlaylist ?? currentPlaylistId);
}
