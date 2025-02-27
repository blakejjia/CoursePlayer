part of 'song_lists_page_bloc.dart';

@immutable
sealed class SongListPageEvent {}

final class SongListLocateAlbum extends SongListPageEvent {
  final Album album;

  SongListLocateAlbum(this.album);
}


final class UpdateSongListEvent extends SongListPageEvent {
}