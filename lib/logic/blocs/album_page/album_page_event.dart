part of 'album_page_bloc.dart';

@immutable
sealed class AlbumPageEvent {}

final class AudioInfoLocatePlaylist extends AlbumPageEvent {
  final Playlist playlist;

  AudioInfoLocatePlaylist(this.playlist);
}