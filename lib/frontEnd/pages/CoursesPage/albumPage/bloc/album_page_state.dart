part of 'album_page_cubit.dart';

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

/// [AlbumPageState] is the base state for the [AlbumPageCubit].
abstract class AlbumPageState {
  /// Whether the playlist is displayed in grid view or list view.
  final bool isGridView;

  const AlbumPageState({required this.isGridView});

  AlbumPageState copyWith({bool? isGridView});
  Map<String, dynamic> toMap();
  factory AlbumPageState.fromMap(Map<String, dynamic> map) {
    if (map['isGridView'] == null) {
      return const AlbumPageInitial(isGridView: false);
    } else if (map['latestPlayed'] != null) {
      return AlbumPageIdeal.fromMap(map);
    } else {
      return AlbumPageInitial.fromMap(map);
    }
  }
}

/// [AlbumPageInitial] represents the initial state of the [AlbumPageCubit].
class AlbumPageInitial extends AlbumPageState {
  const AlbumPageInitial({required super.isGridView});

  @override
  AlbumPageInitial copyWith({bool? isGridView}) {
    return AlbumPageInitial(
      isGridView: isGridView ?? this.isGridView,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'isGridView': isGridView,
    };
  }

  factory AlbumPageInitial.fromMap(Map<String, dynamic> map) {
    return AlbumPageInitial(
      isGridView: map['isGridView'] as bool? ?? false,
    );
  }
}

/// [AlbumPageIdeal] represents the ideal state of the [AlbumPageCubit].
class AlbumPageIdeal extends AlbumPageState {
  /// All albums in the database to display, initialized when app loads.
  final List<Album> albums;

  /// The latest played song, represented as a pair of [Album] and [SongId].
  final LatestPlayed? latestPlayed;

  const AlbumPageIdeal({
    required super.isGridView,
    required this.albums,
    this.latestPlayed,
  });

  @override
  AlbumPageIdeal copyWith({
    bool? isGridView,
    LatestPlayed? latestPlayed,
    List<Album>? albums,
  }) {
    return AlbumPageIdeal(
      isGridView: isGridView ?? this.isGridView,
      latestPlayed: latestPlayed ?? this.latestPlayed,
      albums: albums ?? this.albums,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'isGridView': isGridView,
      'latestPlayed': latestPlayed?.toMap(),
      // albums 的序列化方式依据 Album 的实现而定
    };
  }

  factory AlbumPageIdeal.fromMap(Map<String, dynamic> map) {
    return AlbumPageIdeal(
      isGridView: map['isGridView'] as bool? ?? false,
      latestPlayed: map['latestPlayed'] != null
          ? LatestPlayed.fromMap(map['latestPlayed'] as Map<String, dynamic>)
          : null,
      albums: [],
    );
  }
}
