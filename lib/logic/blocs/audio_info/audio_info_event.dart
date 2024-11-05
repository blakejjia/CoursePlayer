part of 'audio_info_bloc.dart';

@immutable
sealed class AudioInfoEvent {}

final class AudioInfoLocatePlaylist extends AudioInfoEvent {
  final Playlist playlist;

  AudioInfoLocatePlaylist(this.playlist);
}

final class AudioInfoLocateSong extends AudioInfoEvent {
  final int index;
  final Playlist indexPlaylist;

  AudioInfoLocateSong(this.indexPlaylist, this.index);
}

final class _AudioInfoUpdateIndex extends AudioInfoEvent{
  final int index;

  _AudioInfoUpdateIndex(this.index);
}
