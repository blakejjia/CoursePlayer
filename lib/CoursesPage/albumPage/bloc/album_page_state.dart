part of './album_page_cubit.dart';

/// [AlbumPageState] is the state of the [AlbumPageCubit].
class AlbumPageState {

  /// Whether the playlist is displayed in grid view or list view.
  final bool isGridView;

  /// All albums in the database to display, initialized when app loads
  final List<Album> albums;

  /// The latest played song, serialize in format below
  /// [id, index, position]
  final List<int>? latestPlayed;

  const AlbumPageState(
      {required this.isGridView, this.latestPlayed, required this.albums});

  AlbumPageState copyWith({
    bool? isGridView,
    List<int>? latestPlayed,
    List<Album>? albums,
  }) {
    return AlbumPageState(
      isGridView: isGridView ?? this.isGridView,
      latestPlayed: latestPlayed ?? this.latestPlayed,
      albums: albums ?? this.albums,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isGridView': isGridView,
      'latestPlayed': latestPlayed,
    };
  }

  // 从 Map 转换回对象
  factory AlbumPageState.fromMap(Map<String, dynamic> map) {
    return AlbumPageState(
      isGridView: map['isGridView'] as bool? ?? false,
      latestPlayed: map['latestPlayed'] != null
          ? List<int>.from(map['latestPlayed'])
          : null,
      albums: [],
    );
  }
}
