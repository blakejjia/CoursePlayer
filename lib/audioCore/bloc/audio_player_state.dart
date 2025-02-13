part of 'audio_player_bloc.dart';

class AudioPlayerState {

  /// [mediaItem] is the current playing media item
  /// use to update duration primarily
  final MediaItem mediaItem;

  /// [playbackState] is the current playback state
  /// use to update playing or nor primarily
  final PlaybackState playbackState;

  /// [currentPlaylistId] is the id of the current playlist
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
