import 'package:course_player/data/models/models.dart';
import 'package:course_player/logic/blocs/album_page/album_page_bloc.dart';
import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:course_player/logic/blocs/playlist_page/playlist_page_cubit.dart';
import 'package:course_player/presentation/widgets/audio_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlbumSongsView extends StatelessWidget {
  const AlbumSongsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumPageBloc, AlbumPageState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(state.playlist?.title ?? "unknown playlist"),
            ),
            bottomNavigationBar: const AudioBottomSheet(),
            body: switch (state.playlist) {
              Playlist() => switch (state.buffer) {
                  [...] => ListView.builder(
                      itemCount: state.buffer!.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _heading(context, state);
                        } else {
                          return _songTile(context, state,
                              state.buffer![index - 1], index - 1);
                        }
                      },
                    ),
                  null => const Center(
                      child: Text("空空如也"),
                    ),
                },
              null => const Center(
                  child: Text("请选择一个播放列表"),
                ),
            });
      },
    );
  }
}

Widget _songTile(
    BuildContext context, AlbumPageState audioInfoState, Song song, int index) {
  return InkWell(
      onTap: () {
        context
            .read<AudioPlayerBloc>()
            .add(LocateAudio(index, audioInfoState.buffer!, null));
      },
      child:

          /// check if the tile is selected or not
          BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
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
    color: Theme.of(context).colorScheme.primaryFixed,
    child: _songTileNormal(song),
  );
}

/// when not selected, song tile look like this
ListTile _songTileNormal(Song song) {
  return ListTile(
    title: Text(_formatTitle(song.title)),
    subtitle: Row(
      children: [
        Text(song.artist),
        const SizedBox(
          width: 20,
        ),
        Text(_formatDuration(song.length))
      ],
    ),
    trailing: const Icon(Icons.more_vert),
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

Widget _heading(BuildContext context, AlbumPageState state) {
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
          state.playlist!.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Text(
          state.playlist!.author,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      ElevatedButton(
          onPressed: () {
            // [index, positionInMilliSeconds]
            List<int>? playHistory = context
                .read<PlaylistPageCubit>()
                .state
                .playHistory[state.playlist!.id];
            int? index = playHistory?[0];
            int? position = playHistory?[1];
            context
                .read<AudioPlayerBloc>()
                .add(LocateAudio(index, state.buffer!, position));
          },
          child: const Text("继续播放")),
    ],
  );
}
