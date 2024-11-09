part of 'audio_info_bloc.dart';

@immutable
sealed class AudioInfoEvent {}

final class AudioInfoLocatePlaylist extends AudioInfoEvent {
  final Playlist playlist;

  AudioInfoLocatePlaylist(this.playlist);
}

final class AudioInfoLocateSong extends AudioInfoEvent {
  final Song song;

  AudioInfoLocateSong(this.song);
}

final class _AudioInfoUpdate extends AudioInfoEvent{
  final Song song;

  _AudioInfoUpdate(this.song);
}