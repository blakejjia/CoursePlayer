import 'package:lemon/CoursesPage/songListPage/bloc/song_lists_page_bloc.dart';
import 'package:lemon/common/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../audioCore/bloc/audio_player_bloc.dart';
import '../../audioCore/audio_bottom_sheet.dart';
import 'functions.dart';

/// [SongsListPage] is a view that shows all songs in an album.
/// listens to [AlbumPageBloc] and [AudioPlayerBloc].
class SongsListPage extends StatelessWidget {
  const SongsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongListPageBloc, SongListPageState>(
      builder: (context, state) {
        if (state is SongListPageLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SongListPageReady) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.album.title),
            ),
            bottomNavigationBar: const AudioBottomSheet(),
            body: switch (state.buffer) {
              [...] => ListView.builder(
                  itemCount: state.buffer!.length + 1,
                  itemBuilder: (context, index) {
                    /// Title section
                    if (index == 0) {
                      return Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 2,
                            child: state.picture != null
                                ? Image.memory(state.picture!)
                                : Image.asset("assets/default_cover.jpeg"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                            child: Text(
                              state.album.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Text(
                              state.album.author,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                context.read<AudioPlayerBloc>().add(LocateAudio(
                                    state.album, state.album.lastPlayedIndex));
                              },
                              child: Text(contiButton(state)))
                        ],
                      );
                    } else {
                      /// song tile section
                      return _songTile(context, state, index);
                    }
                  },
                ),
              null => const Center(
                  child: Text("nothing here"),
                ),
            },
          );
        } else {
          return Center(
            child: Text(state.toString()),
          );
        }
      },
    );
  }
}

Widget _songTile(BuildContext context, SongListPageReady state, int index) {
  Album album = state.album;
  List<Song>? buffer = state.buffer;
  Song song = state.buffer![index - 1];
  return InkWell(onTap: () {
    context
        .read<AudioPlayerBloc>()
        .add(LocateAudio(album, song.id, buffer: buffer));
  }, child:
      BlocBuilder<AudioPlayerBloc, AudioPlayerState>(builder: (context, state) {
    if (state is AudioPlayerIdeal && song.id == int.parse(state.mediaItem.id)) {
      return _songTileSelected(context, song);
    } else {
      return _songTileNormal(context, song);
    }
  }));
}

/// when selected, song tile look like this
Widget _songTileSelected(BuildContext context, Song song) {
  return Container(
    color: Theme.of(context).colorScheme.primaryFixed.withAlpha(100),
    child: _songTileNormal(context, song),
  );
}

/// when not selected, song tile look like this
Widget _songTileNormal(BuildContext context, Song song) {
  return ListTile(
    leading: Text("${song.track}", style: Theme.of(context).textTheme.titleMedium),
    title: Text(formatTitle(song)),
    subtitle: Text(formatSubtitle(song)),
  );
}
