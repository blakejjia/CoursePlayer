part of 'playlist_page_cubit.dart';

class PlaylistPageState {
  final bool isGridView;
  // {
  //  playlistId:
  //    [index, positionInMilliSeconds]
  //  }
  final Map<int, List<int>> playHistory;
  // [id, index, position]
  final List<int>? latestPlayed;

  const PlaylistPageState(
      {required this.isGridView, this.latestPlayed, required this.playHistory});

  PlaylistPageState copyWith({
    bool? isGridView,
    List<int>? latestPlayed,
    Map<int, List<int>>? playHistory,
  }) {
    return PlaylistPageState(
      isGridView: isGridView ?? this.isGridView,
      latestPlayed: latestPlayed ?? this.latestPlayed,
      playHistory: playHistory ?? this.playHistory,
    );
  }

  // 将对象转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'isGridView': isGridView,
      'latestPlayed': latestPlayed,
      'playHistory': playHistory.map(
        (key, value) => MapEntry(
          key.toString(), // 将 int 键转换为 String
          value, // 保持值为 List<int>
        ),
      ),
    };
  }

  // 从 Map 转换回对象
  factory PlaylistPageState.fromMap(Map<String, dynamic> map) {
    return PlaylistPageState(
      isGridView: map['isGridView'] as bool? ?? false,
      latestPlayed: map['latestPlayed'] != null
          ? List<int>.from(map['latestPlayed'])
          : null,
      playHistory: (map['playHistory'] as Map<String, dynamic>? ?? {}).map(
        (key, value) {
          // 将键从 String 转为 int，并确保值为 List<int>
          return MapEntry(
            int.tryParse(key) ?? 0, // 如果转换失败，提供默认值 0
            List<int>.from(value as List), // 将 value 转换为 List<int>
          );
        },
      ),
    );
  }
}
