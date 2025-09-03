import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:lemon/features/playList/providers/song_list_state.dart';
import 'package:lemon/main.dart';

class SongListNotifier extends StateNotifier<SongListState> {
  final Ref ref;
  SongListNotifier(this.ref) : super(const SongListState.loading());

  Future<void> locateAlbum(Album album) async {
    state = const SongListState.loading();
    final songs =
        await ref.read(songRepositoryProvider).getSongsByAlbumId(album.id);
    state = SongListState(
      album: album,
      buffer: songs,
      isLoading: false,
    );
  }

  Future<void> refreshSongs() async {
    final current = state;
    if (!current.isReady || current.album == null) return;
    final songs = await ref
        .read(songRepositoryProvider)
        .getSongsByAlbumId(current.album!.id);
    final album =
        await ref.read(albumRepositoryProvider).getAlbumById(current.album!.id);
    state = current.copyWith(buffer: songs, album: album);
  }
}

final songListProvider =
    StateNotifierProvider<SongListNotifier, SongListState>((ref) {
  return SongListNotifier(ref);
});
