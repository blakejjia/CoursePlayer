import 'dart:typed_data';

import 'package:lemon/core/data/models/media_library_schema.dart';

class SongListState {
  final Album? album;
  final List<Song>? buffer;
  final bool isLoading;

  const SongListState({
    required this.album,
    required this.buffer,
    required this.isLoading,
  });

  const SongListState.loading()
      : album = null,
        buffer = null,
        isLoading = true;

  bool get isReady => !isLoading && album != null;

  SongListState copyWith({
    Album? album,
    List<Song>? buffer,
    Uint8List? picture,
    bool? isLoading,
  }) {
    return SongListState(
      album: album ?? this.album,
      buffer: buffer ?? this.buffer,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return 'SongListState(album: $album, buffer: $buffer, isLoading: $isLoading)';
  }
}
