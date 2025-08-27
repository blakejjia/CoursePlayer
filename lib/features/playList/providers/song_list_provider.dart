import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/backEnd/json/models.dart';
import 'package:lemon/features/playList/providers/song_list_state.dart';
import 'package:lemon/main.dart';

class SongListNotifier extends StateNotifier<SongListState> {
  SongListNotifier() : super(const SongListState.loading());

  Future<void> locateAlbum(Album album) async {
    state = const SongListState.loading();
    final songs = await providerContainer
        .read(songRepositoryProvider)
        .getSongsByAlbumId(album.id);
    final Uint8List? picture = await providerContainer
        .read(coversRepositoryProvider)
        .getCoverUint8ListByPlaylist(album);
    state = SongListState(
      album: album,
      buffer: songs,
      picture: picture,
      isLoading: false,
    );
  }

  Future<void> refreshSongs() async {
    final current = state;
    if (!current.isReady || current.album == null) return;
    final songs = await providerContainer
        .read(songRepositoryProvider)
        .getSongsByAlbumId(current.album!.id);
    final album = await providerContainer
        .read(albumRepositoryProvider)
        .getAlbumById(current.album!.id);
    state = current.copyWith(buffer: songs, album: album);
  }
}

final songListProvider =
    StateNotifierProvider<SongListNotifier, SongListState>((ref) {
  return SongListNotifier();
});
