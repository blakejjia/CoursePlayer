part of './album_page_cubit.dart';

/// Represents a pair of Album and SongId.
class LatestPlayed {
  final Album album;
  final int songId;

  const LatestPlayed(this.album, this.songId);

  Map<String, dynamic> toMap() {
    return {
      'album': album.toJson(), // 假定 Album 实现了 toMap()
      'songId': songId,
    };
  }

  factory LatestPlayed.fromMap(Map<String, dynamic> map) {
    return LatestPlayed(
      Album.fromJson(map['album'] as Map<String, dynamic>),
      map['songId'] as int,
    );
  }
}

/// [AlbumPageState] is the state of the [AlbumPageCubit].
class AlbumPageState {
  /// Whether the playlist is displayed in grid view or list view.
  final bool isGridView;

  /// All albums in the database to display, initialized when app loads.
  final List<Album> albums;

  /// The latest played song, represented as a pair of [Album] and [SongId].
  final LatestPlayed? latestPlayed;

  const AlbumPageState({
    required this.isGridView,
    required this.albums,
    this.latestPlayed,
  });

  AlbumPageState copyWith({
    bool? isGridView,
    LatestPlayed? latestPlayed,
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
      'latestPlayed': latestPlayed?.toMap(),
      // albums 的序列化方式依据 Album 的实现而定
    };
  }

  factory AlbumPageState.fromMap(Map<String, dynamic> map) {
    return AlbumPageState(
      isGridView: map['isGridView'] as bool? ?? false,
      latestPlayed: map['latestPlayed'] != null
          ? LatestPlayed.fromMap(map['latestPlayed'] as Map<String, dynamic>)
          : null,
      albums: [], // 根据实际需求解析 albums
    );
  }
}
