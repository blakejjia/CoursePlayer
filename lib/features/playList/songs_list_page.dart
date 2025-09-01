import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:lemon/features/playList/widgets/popup_actions.dart';
import 'package:lemon/features/playList/widgets/tiles.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/providers/audio/audio_player_provider.dart';
import '../audioPage/audio_bottom_sheet.dart';
import 'widgets/utils/texts.dart';

/// [SongsListPage] is a view that shows all songs in an album.
/// Uses Riverpod providers for album/song list and audio player.
class SongsListPage extends ConsumerWidget {
  const SongsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songListProvider);
    if (state.isLoading) {
      return Center(
        child: Text(state.toString()),
      );
    }
    if (!state.isReady || state.album == null) {
      return const Scaffold(
        body: Center(child: Text('nothing here')),
      );
    }
    final ready = state; // convenience alias
    return Scaffold(
      appBar: AppBar(
        title: Text(ready.album!.title),
        actions: [
          PopupMenu(),
        ],
      ),
      bottomNavigationBar: const AudioBottomSheet(),
      body: switch (ready.buffer) {
        [...] => ListView.builder(
            itemCount: ready.buffer!.length + 1,
            itemBuilder: (context, index) {
              /// Title section
              if (index == 0) {
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: Image.asset(
                          "assets/default_cover.jpeg"), // TODO: load cover dynamically
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                      child: Text(
                        ready.album!.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text(
                        ready.album!.author,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          ref.read(audioPlayerProvider.notifier).locateAudio(
                              ready.album!, ready.album!.lastPlayedIndex);
                        },
                        child: Text(contiButton(ready)))
                  ],
                );
              } else {
                /// song tile section
                return _songTile(context, ref, ready, index);
              }
            },
          ),
        null => const Center(
            child: Text("nothing here"),
          ),
      },
    );
  }
}

Widget _songTile(
    BuildContext context, WidgetRef ref, dynamic state, int index) {
  Album album = state.album!;
  List<Song>? buffer = state.buffer;
  Song song = state.buffer![index - 1];
  return InkWell(onTap: () {
    ref
        .read(audioPlayerProvider.notifier)
        .locateAudio(album, song.id, buffer: buffer);
  }, child: Consumer(builder: (context, ref, _) {
    final audioState = ref.watch(audioPlayerProvider);
    if (audioState is AudioPlayerIdeal &&
        song.id == int.tryParse(audioState.mediaItem.id)) {
      return selectIndicator(context, song);
    }
    return songTileNormal(context, song);
  }));
}
