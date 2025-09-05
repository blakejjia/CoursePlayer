import 'dart:typed_data';

import 'package:lemon/core/data/models/models.dart';

class SongListState {
  final Album? album;
  final String currentPlayingSongId;

  const SongListState({
    required this.album,
    this.currentPlayingSongId = '',
  });

  bool get isReady => album != null;

  SongListState copyWith({
    Album? album,
    List<Song>? buffer,
    Uint8List? picture,
    bool? isLoading,
    String? currentPlayingSongId,
  }) {
    return SongListState(
      album: album ?? this.album,
      currentPlayingSongId: currentPlayingSongId ?? this.currentPlayingSongId,
    );
  }

  @override
  String toString() {
    return 'SongListState(album: $album, currentPlayingSongId: $currentPlayingSongId)';
  }
}
