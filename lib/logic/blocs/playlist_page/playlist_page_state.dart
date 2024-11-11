part of 'playlist_page_cubit.dart';

class PlaylistPageState extends Equatable {
  final bool isGridView;
  // {
  //  playlistId:
  //    [index, positionInMilliSeconds]
  //  }
  final Map<int, List<int>> playHistory;

  const PlaylistPageState(
      {required this.isGridView, required this.playHistory});

  @override
  String toString() {
    return 'SettingsState{isListView: $isGridView, playHistory: $playHistory}';
  }

  PlaylistPageState copyWith({
    bool? isGridView,
    Map<int, List<int>>? playHistory,
  }) {
    return PlaylistPageState(
      isGridView: isGridView ?? this.isGridView,
      playHistory: playHistory ?? this.playHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isGridView': isGridView,
      'playHistory': playHistory.map(
        (key, value) => MapEntry(
          key.toString(), // 将 int 键转换为 String
          value, // 保持值为 List<int>
        ),
      ),
    };
  }

  factory PlaylistPageState.fromMap(Map<String, dynamic> map) {
    return PlaylistPageState(
      isGridView: map['isGridView'] as bool? ?? false,
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

  @override
  List<Object> get props => [isGridView, playHistory];
}
