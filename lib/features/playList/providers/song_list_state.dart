import 'dart:typed_data';

import 'package:lemon/core/backEnd/data/models/models.dart';

class SongListState {
  final Album? album;
  final List<Song>? buffer;
  final Uint8List? picture;
  final bool isLoading;

  const SongListState({
    required this.album,
    required this.buffer,
    required this.picture,
    required this.isLoading,
  });

  const SongListState.loading()
      : album = null,
        buffer = null,
        picture = null,
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
      picture: picture ?? this.picture,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
