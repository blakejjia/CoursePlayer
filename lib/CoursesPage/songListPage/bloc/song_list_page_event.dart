part of 'song_lists_page_bloc.dart';

@immutable
sealed class SongListPageEvent {}

final class AudioInfoLocatePlaylist extends SongListPageEvent {
  final Album album;

  AudioInfoLocatePlaylist(this.album);
}

final class UpdateSongListEvent extends SongListPageEvent {}