part of 'one_playlist_cubit.dart';

class OnePlaylistState {
  final int sortBy;

//<editor-fold desc="Data Methods">
  const OnePlaylistState({
    required this.sortBy,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnePlaylistState &&
          runtimeType == other.runtimeType &&
          sortBy == other.sortBy);

  @override
  int get hashCode => sortBy.hashCode;

  @override
  String toString() {
    return 'OnePlaylistState{' ' sortBy: $sortBy,' '}';
  }

  OnePlaylistState copyWith({
    int? sortBy,
  }) {
    return OnePlaylistState(
      sortBy: sortBy ?? this.sortBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sortBy': sortBy,
    };
  }

  factory OnePlaylistState.fromMap(Map<String, dynamic> map) {
    return OnePlaylistState(
      sortBy: map['sortBy'] as int,
    );
  }

//</editor-fold>
}
