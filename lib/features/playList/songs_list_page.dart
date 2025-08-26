import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:lemon/features/playList/widgets/ChangeArtistPopUp.dart';
import 'package:lemon/features/playList/widgets/song_list_widgets.dart';
import 'package:lemon/core/backEnd/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/bloc/audio_player_bloc.dart';
import '../audioPage/audio_bottom_sheet.dart';
import 'logic/functions.dart';

/// [SongsListPage] is a view that shows all songs in an album.
/// listens to [AlbumPageBloc] and [AudioPlayerBloc].
class SongsListPage extends ConsumerWidget {
  const SongsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songListProvider);
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
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
          PopupMenuButton<String>(
            onSelected: (_) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      ChangeArtistPopUp(ready.album!.sourcePath, ready.buffer));
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                    value: 'ListView', child: Text("change artist name")),
              ];
            },
          ),
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
                      child: ready.picture != null
                          ? Image.memory(ready.picture!)
                          : Image.asset("assets/default_cover.jpeg"),
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
                          context.read<AudioPlayerBloc>().add(LocateAudio(
                              ready.album!, ready.album!.lastPlayedIndex));
                        },
                        child: Text(contiButton(ready)))
                  ],
                );
              } else {
                /// song tile section
                return _songTile(context, ready, index);
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

Widget _songTile(BuildContext context, dynamic state, int index) {
  Album album = state.album!;
  List<Song>? buffer = state.buffer;
  Song song = state.buffer![index - 1];
  return InkWell(onTap: () {
    context
        .read<AudioPlayerBloc>()
        .add(LocateAudio(album, song.id, buffer: buffer));
  }, child:
      BlocBuilder<AudioPlayerBloc, AudioPlayerState>(builder: (context, state) {
    if (state is AudioPlayerIdeal && song.id == int.parse(state.mediaItem.id)) {
      return selectIndicator(context, song);
    } else {
      return songTileNormal(context, song);
    }
  }));
}
