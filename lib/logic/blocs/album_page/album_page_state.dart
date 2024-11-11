part of 'album_page_bloc.dart';

class AlbumPageState {
  final Playlist? playlist;
  final List<Song>? buffer;
  final Uint8List? picture;

  const AlbumPageState({this.playlist, this.buffer, this.picture});

  AlbumPageState copyWith({
    Playlist? playlist,
    List<Song>? buffer,
    Uint8List? picture,
  }) {
    return AlbumPageState(
      playlist: playlist ?? this.playlist,
      buffer: buffer ?? this.buffer,
      picture: picture ?? this.picture,
    );
  }
}
