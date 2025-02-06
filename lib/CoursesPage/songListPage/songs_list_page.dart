import 'package:lemon/CoursesPage/songListPage/bloc/song_lists_page_bloc.dart';
import 'package:lemon/audioPage/presentation/audio_bottom_sheet.dart';
import 'package:lemon/common/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/logic/bloc/audio_player/audio_player_bloc.dart';

/// [SongsListPage] is a view that shows all songs in an album.
/// listens to [AlbumPageBloc] and [AudioPlayerBloc].
class SongsListPage extends StatelessWidget {
  const SongsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongListPageBloc, SongListPageState>(
      builder: (context, state) {
        return (state is AlbumPageReady)
            ? Scaffold(
                appBar: AppBar(
                  title: Text(state.playlist.title),
                ),
                bottomNavigationBar: const AudioBottomSheet(),
                body: switch (state.buffer) {
                  [...] => ListView.builder(
                      itemCount: state.buffer!.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _heading(context, state);
                        } else {
                          return _songTile(context, state.playlist,
                              state.buffer![index - 1], index - 1);
                        }
                      },
                    ),
                  null => const Center(
                      child: Text("nothing here"),
                    ),
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

Widget _songTile(
    BuildContext context, Album playlist, Song song, int index) {
  return InkWell(
      onTap: () {
        context.read<AudioPlayerBloc>().add(LocateAudio(playlist.id, index, 0));
      },
      child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
          buildWhen: (prev, curr) => prev.mediaItem != curr.mediaItem,
          builder: (context, state) {
            if (song.id == int.parse(state.mediaItem.id)) {
              return _songTileSelected(context, song);
            } else {
              return _songTileNormal(song);
            }
          }));
}

/// when selected, song tile look like this
Container _songTileSelected(BuildContext context, Song song) {
  return Container(
    color: Theme.of(context).colorScheme.primaryFixed.withAlpha(100),
    child: _songTileNormal(song),
  );
}

/// when not selected, song tile look like this
ListTile _songTileNormal(Song song) {
  return ListTile(
    title: Text(_formatTitle(song.title)),
    subtitle: Row(
      children: [
        Text(
          song.artist,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          width: 20,
        ),
        Text(_formatDuration(song.length))
      ],
    ),
  );
}

String _formatDuration(int duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  int hours = duration ~/ 3600;
  int minutes = (duration % 3600) ~/ 60;
  int seconds = duration % 60;
  String twoDigitMinutes = twoDigits(minutes);
  String twoDigitSeconds = twoDigits(seconds);
  if (hours > 0) {
    return "${twoDigits(hours)}:$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

String _formatTitle(String title) {
  int lastDotIndex = title.lastIndexOf('.');
  if (lastDotIndex != -1) {
    return title.substring(0, lastDotIndex);
  }
  return title;
}

Widget _heading(BuildContext context, AlbumPageReady state) {
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
          state.playlist.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Text(
          state.playlist.author,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      // TODO:bring back
      // BlocBuilder<AlbumPageCubit,AlbumPageState>(
      //     buildWhen: (prev, curr) =>
      //         prev.progress[state.playlist.id]?[0] !=
      //         curr.progress[state.playlist.id]?[0],
      //     builder: (context, playlistPageState) {
      //       // [index, positionInMilliSeconds]
      //       List<int>? playHistory =
      //           playlistPageState.progress[state.playlist.id];
      //       int index = playHistory?[0] ?? 0;
      //       int position = playHistory?[1] ?? 0;
      //       return ElevatedButton(
      //           onPressed: () {
      //             context
      //                 .read<AudioPlayerBloc>()
      //                 .add(LocateAudio(state.playlist.id, index, position));
      //           },
      //           child: Text(index == 0 ? "start playing" : "continue: #${index+1}"));
      //     }),
    ],
  );
}
