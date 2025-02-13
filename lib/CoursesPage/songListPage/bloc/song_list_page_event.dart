part of 'song_lists_page_bloc.dart';

@immutable
sealed class SongListPageEvent {}

final class SongListLocatePlaylist extends SongListPageEvent {
  final Album album;

  SongListLocatePlaylist(this.album);
}


final class UpdateSongListEvent extends SongListPageEvent {
}