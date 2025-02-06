part of './album_page_cubit.dart';

/// [AlbumPageState] is the state of the [AlbumPageCubit].
class AlbumPageState {

  /// Whether the playlist is displayed in grid view or list view.
  final bool isGridView;

  /// The progress of each playlist. Serialize in format below
  /// { playlistId: [current, total] }
  final Map<int, List<int>> progress;

  /// The latest played song, serialize in format below
  /// [id, index, position]
  final List<int>? latestPlayed;

  const AlbumPageState(
      {required this.isGridView, this.latestPlayed, required this.progress});

  AlbumPageState copyWith({
    bool? isGridView,
    List<int>? latestPlayed,
    Map<int, List<int>>? progress,
  }) {
    return AlbumPageState(
      isGridView: isGridView ?? this.isGridView,
      latestPlayed: latestPlayed ?? this.latestPlayed,
      progress: progress ?? this.progress,
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
      progress: {},
    );
  }
}
