part of 'playlist_page_cubit.dart';

class PlaylistPageState extends Equatable {
  final bool islistview;

//<editor-fold desc="Data Methods">
  const PlaylistPageState({
    required this.islistview,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is PlaylistPageState &&
              runtimeType == other.runtimeType &&
              islistview == other.islistview);

  @override
  int get hashCode => islistview.hashCode;

  @override
  String toString() {
    return 'SettingsState{ islistview: $islistview,}';
  }

  PlaylistPageState copyWith({
    bool? isListView,
  }) {
    return PlaylistPageState(
      islistview: isListView ?? islistview,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'islistview': islistview,
    };
  }

  factory PlaylistPageState.fromMap(Map<String, dynamic> map) {
    return PlaylistPageState(
      islistview: map['islistview'] as bool,
    );
  }

  @override
  List<Object> get props => [islistview];
//</editor-fold>
}