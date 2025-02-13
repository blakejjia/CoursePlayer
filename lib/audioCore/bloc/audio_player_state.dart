part of 'audio_player_bloc.dart';

@immutable
class AudioPlayerState {}

class AudioPlayerInitial extends AudioPlayerState{}

class AudioPlayerIdeal extends AudioPlayerState{
  /// [mediaItem] is the current playing media item
  /// use to update duration primarily
  final MediaItem mediaItem;

  /// [playbackState] is the current playback state
  /// use to update playing or nor primarily
  final PlaybackState playbackState;

  /// [album] is the id of the current playlist
  final Album album;

  AudioPlayerIdeal(this.mediaItem, this.playbackState, this.album);

  copyWith(
      {MediaItem? mediaItem,
        PlaybackState? playbackState,
        Album? album}) =>
      AudioPlayerIdeal(
          mediaItem ?? this.mediaItem,
          playbackState ?? this.playbackState,
          album ?? this.album);
}