part of 'song_lists_page_bloc.dart';

@immutable
class SongListPageState {
}

class AlbumPageLoading extends SongListPageState{
  AlbumPageLoading();
}

class AlbumPageReady extends SongListPageState{
  final Album playlist;
  final List<Song>? buffer;
  final Uint8List? picture;

  AlbumPageReady({required this.playlist, this.buffer, this.picture});

  AlbumPageReady copyWith({
    Album? playlist,
    List<Song>? buffer,
    Uint8List? picture,
  }) {
    return AlbumPageReady(
      playlist: playlist ?? this.playlist,
      buffer: buffer ?? this.buffer,
      picture: picture ?? this.picture,
    );
  }
}