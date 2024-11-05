part of 'one_playlist_bloc.dart';

@immutable
sealed class OnePlaylistEvent {}

final class OnePlayListSelected extends OnePlaylistEvent{
  // when user select a playlist and go into OnePlaylistPage
  final Playlist playlist;

  OnePlayListSelected(this.playlist);
}

final class OnePlayListPlay extends OnePlaylistEvent{
  // when user click on a music in the page to play
  final int index;

  OnePlayListPlay(this.index);
}