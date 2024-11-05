part of 'one_playlist_bloc.dart';

@immutable
sealed class OnePlaylistState {
  final Playlist? currentPlaylist;
  final List<Song>? songList;
  final Uint8List? picture;

  const OnePlaylistState(this.currentPlaylist, this.songList, this.picture);
}

final class OnePlaylistIdle extends OnePlaylistState {
  // after user selected a playlist and go into playlist Page
  const OnePlaylistIdle(super.currentPlaylist, super.songList, super.picture);
}

final class OnePlaylistInAudio extends OnePlaylistState {
  // after user clicked on one audio to play it.
  final int index;
  const OnePlaylistInAudio(
      super.currentPlaylist, super.songList, super.picture, this.index);
}
