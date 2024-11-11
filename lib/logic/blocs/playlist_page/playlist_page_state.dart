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
    return {'isGridView': isGridView, 'playHistory': playHistory};
  }

  factory PlaylistPageState.fromMap(Map<String, dynamic> map) {
    return PlaylistPageState(
      isGridView: map['isGridView'] as bool,
      playHistory: (map['playHistory'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          int.parse(key), // 将键从 String 转为 int
          List<int>.from(value), // 将值转为 List<int>
        ),
      ),
    );
  }

  @override
  List<Object> get props => [isGridView, playHistory];
}
