part of 'song_lists_page_bloc.dart';

/// [SongListPageState] is the state of [SongListPageBloc]
/// shows the state of the page
@immutable
class SongListPageState {
}

/// [SongListPageLoading] is the state when the page is loading
/// called when the page is first loaded
class SongListPageLoading extends SongListPageState{
  SongListPageLoading();
}

/// [SongListPageReady] is the state when the page is ready
/// called when the page is ready to show
class SongListPageReady extends SongListPageState{

  /// [album] is the album that the page is showing
  final Album album;

  /// [buffer] is the list of songs in the album
  final List<Song>? buffer;

  /// [picture] is the cover image of the album
  final Uint8List? picture;

  SongListPageReady({required this.album, this.buffer, this.picture});

  SongListPageReady copyWith({
    Album? album,
    List<Song>? buffer,
    Uint8List? picture,
  }) {
    return SongListPageReady(
      album: album ?? this.album,
      buffer: buffer ?? this.buffer,
      picture: picture ?? this.picture,
    );
  }
}