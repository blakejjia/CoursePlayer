import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:lemon/features/playList/widgets/popup_actions.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../audioPage/audio_bottom_sheet.dart';
import 'widgets/utils/texts.dart';

/// [SongsListPage] is a view that shows all songs in an album.
/// Uses Riverpod providers for album/song list and audio player.
class SongsListPage extends ConsumerWidget {
  const SongsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(state.album?.title ?? 'Album'),
        actions: [
          PopupMenu(),
        ],
      ),
      bottomNavigationBar: const AudioBottomSheet(), //TODO: move to main page
      body: Builder(builder: (context) {
        final album = state.album;
        if (album == null) {
          return const Center(child: Text('No album selected.'));
        }
        if (album.songs.isEmpty) {
          return const Center(child: Text('No songs found in this album.'));
        }

        return ListView.builder(
          itemCount: album.songs.length + 1,
          itemBuilder: (context, index) {
            // Title/header section
            if (index == 0) {
              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    child: Image.asset("assets/default_cover.jpeg"),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                    child: Text(
                      album.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Text(
                      album.author,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      ref.read(songListProvider.notifier).playSong(
                            album.lastPlayedSong!,
                          );
                    },
                    child: Text(continuePrompt(state)),
                  ),
                ],
              );
            }

            // Song tile section
            return _SongTile(song: album.songs[index - 1], index: index);
          },
        );
      }),
    );
  }
}

class _SongTile extends ConsumerWidget {
  const _SongTile({required this.song, required this.index});

  final Song song;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(onTap: () {
      ref.read(songListProvider.notifier).playSong(song);
    }, child: Builder(builder: (context) {
      final audioState = ref.watch(songListProvider).currentPlayingSongId;
      return Container(
        color: audioState == song.id
            ? Theme.of(context).colorScheme.primaryFixed
            : Colors.transparent,
        child: ListTile(
            leading: song.track != null
                ? Text("${song.track}",
                    style: Theme.of(context).textTheme.titleMedium)
                : null,
            title: Text(formatTitle(song)),
            subtitle: Text(formatSubtitle(song))),
      );
    }));
  }
}
