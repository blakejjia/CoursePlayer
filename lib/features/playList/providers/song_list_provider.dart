import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/audio/providers/audio/audio_player_provider.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:lemon/features/playList/providers/song_list_state.dart';
import 'package:lemon/main.dart';

class SongListNotifier extends StateNotifier<SongListState> {
  final Ref ref;
  late final ProviderSubscription<AudioPlayerState> _listener;

  SongListNotifier(this.ref) : super(const SongListState(album: null)) {
    // Listen to audio player provider and update current playing song id
    _listener = ref.listen<AudioPlayerState>(
      audioPlayerProvider,
      (previous, next) {
        // Only handle ideal state which contains mediaItem
        if (next is AudioPlayerIdeal) {
          final id = next.mediaItem.id;
          // update state only if changed
          if (state.currentPlayingSongId != id) {
            debugPrint('Now playing song id: $id');
            state = state.copyWith(currentPlayingSongId: id);
          }
        } else {
          // not playing
          if (state.currentPlayingSongId != '') {
            state = state.copyWith(currentPlayingSongId: '');
          }
        }
      },
    );
  }

  Future<void> locateAlbum(Album album) async {
    state = SongListState(album: album);
    await refreshSongs();
  }

  Future<void> refreshSongs() async {
    if (state.album == null) return;
    final album =
        await ref.read(albumRepositoryProvider).getAlbumById(state.album!.id);
    state = state.copyWith(album: album);
  }

  // audio
  void playSong(Song song) {
    if (state.album == null) return;
    ref.read(audioPlayerProvider.notifier).locateAudio(
          album: state.album!,
          songId: song.id,
        );
  }

  @override
  void dispose() {
    _listener.close();
    super.dispose();
  }
}

final songListProvider =
    StateNotifierProvider<SongListNotifier, SongListState>((ref) {
  return SongListNotifier(ref);
});
