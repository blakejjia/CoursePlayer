part of 'audio_info_bloc.dart';

@immutable
sealed class AudioInfoEvent {}

final class LocateSong extends AudioInfoEvent {
  final int index;
  final Uint8List? image;
  final Playlist playlist;
  final List<Song> songList;

  LocateSong(this.playlist, this.songList, this.index, this.image);
}

final class AudioInfoNextSong extends AudioInfoEvent {}
