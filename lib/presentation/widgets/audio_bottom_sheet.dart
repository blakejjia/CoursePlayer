import 'package:course_player/logic/blocs/audio_info/audio_info_bloc.dart';
import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:course_player/presentation/screens/conditionalPages/audio_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioBottomSheet extends StatelessWidget {
  const AudioBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioInfoBloc, AudioInfoState>(
      buildWhen: (prev, current) {
        if (prev.runtimeType != current.runtimeType) {
          return true;
        } else if (prev is AudioInfoSong &&
            current is AudioInfoSong &&
            (prev.index != current.index ||
                prev.indexPlaylist != current.indexPlaylist)) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state is AudioInfoSong) {
          return InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true, // 让 BottomSheet 覆盖整个屏幕
              builder: (ctx) => Container(
                alignment: Alignment.center,
                child: const AudioPage(),
              ),
            ),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              height: 71,
              child: _content(state, context),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

Widget _content(AudioInfoState audioInfoState, BuildContext context) {
  return Column(
    children: [
      BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
        buildWhen: (prev, current) {
          if (prev.playbackState.position != current.playbackState.position) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return SizedBox(
            height: 3,
            child: LinearProgressIndicator(
              value: (state.mediaItem.duration != null &&
                      state.mediaItem.duration!.inSeconds > 0)
                  ? (state.playbackState.position.inSeconds /
                      state.mediaItem.duration!.inSeconds)
                  : 0,
            ),
          );
        },
      ),
      ListTile(
        title: Text(
          (audioInfoState as AudioInfoSong)
              .indexBuffer[audioInfoState.index]
              .title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: _trailing(context),
      )
    ],
  );
}

Widget _trailing(BuildContext context) {
  return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
    builder: (context, state) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          state.playbackState.playing
              ? IconButton(
                  icon: const Icon(Icons.pause_rounded),
                  iconSize: 40,
                  onPressed: () =>
                      context.read<AudioPlayerBloc>().add(PauseEvent()),
                )
              : IconButton(
                  icon: const Icon(Icons.play_arrow_rounded),
                  iconSize: 40,
                  onPressed: () =>
                      context.read<AudioPlayerBloc>().add(ContinueEvent()),
                ),
          IconButton(
            icon: const Icon(Icons.fast_forward_rounded),
            iconSize: 40,
            onPressed: () => context.read<AudioPlayerBloc>().add(NextEvent()),
          ),
        ],
      );
    },
  );
}
