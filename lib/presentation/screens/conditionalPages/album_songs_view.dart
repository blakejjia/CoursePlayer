import 'dart:typed_data';

import 'package:course_player/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/blocs/audio_player/audio_player_bloc.dart';
import '../../widgets/audio_bottom_sheet.dart';
import '../../../logic/blocs/audio_info/audio_info_bloc.dart';

class AlbumSongsView extends StatelessWidget {
  const AlbumSongsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioInfoBloc, AudioInfoState>(
      buildWhen: (prev, current) {
        if (prev.playlist != current.playlist) {
          return true;
        } else if (prev.runtimeType != current.runtimeType) {
          return true;
        } else if (prev is AudioInfoSong &&
            current is AudioInfoSong &&
            prev.index != current.index) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(state.playlist?.title ?? ""),
            ),
            bottomNavigationBar: const AudioBottomSheet(),
            body: switch (state.playlist) {
              Playlist() => switch (state.buffer) {
                  [...] => ListView.builder(
                    itemCount: state.buffer!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _heading(
                            context, state.playlist!, state.picture);
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
    BuildContext context, AudioInfoState state, Song song, int index) {
  return InkWell(onTap: () {
    context
        .read<AudioInfoBloc>()
        .add(AudioInfoLocateSong(state.playlist!, index));
    context.read<AudioPlayerBloc>().add(LocateAudio(index, state.buffer!));
  }, child: Builder(builder: (context) {
    if (state is AudioInfoSong &&
        state.index == index &&
        state.indexPlaylist == state.playlist) {
      return _songTileSelected(context, song);
    } else {
      return _songTileNormal(song);
    }
  }));
}

// when selected, song tile look like this
Container _songTileSelected(BuildContext context, Song song) {
  return Container(
    color: Theme.of(context).colorScheme.primaryFixed,
    child: _songTileNormal(song),
  );
}

// when not selected, song tile look like this
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

  // 计算小时、分钟和秒
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
  int lastDotIndex = title.lastIndexOf('.'); // 如果存在 '.', 则去掉末尾的后缀
  if (lastDotIndex != -1) {
    return title.substring(0, lastDotIndex);
  }
  return title;
}

Widget _heading(BuildContext context, Playlist playlist, Uint8List? picture) {
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width / 2,
        child: picture != null
            ? Image.memory(picture)
            : Image.asset("assets/default_cover.jpeg"),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Text(
          playlist.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Text(
          playlist.author,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ],
  );
}
