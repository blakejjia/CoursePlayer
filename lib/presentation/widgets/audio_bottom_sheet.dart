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
              child: _bottomSheet(context, state),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}

Widget _bottomSheet(BuildContext context, AudioInfoState audioInfoState) {
  return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
    builder: (context, audioPlayerState) {
      return Column(
        children: [
          ...switch (audioPlayerState) {
            AudioPlayerInitial() => [],
            AudioPlayerPlaying() ||
            AudioPlayerPause() =>
              _content(audioPlayerState, audioInfoState, context),
          }
        ],
      );
    },
  );
}

List<Widget> _content(AudioPlayerState audioPlayerState,
    AudioInfoState audioInfoState, BuildContext context) {
  return [
    SizedBox(
      height: 3,
      child: LinearProgressIndicator(
        value: (audioPlayerState.totalTime.inSeconds > 0)
            ? (audioPlayerState.position.inSeconds /
                audioPlayerState.totalTime.inSeconds)
            : 0,
      ),
    ),
    ListTile(
      title: Text(
        (audioInfoState as AudioInfoSong)
            .indexBuffer[audioInfoState.index]
            .title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _trailing(audioPlayerState, context),
    )
  ];
}

Row _trailing(AudioPlayerState audioPlayerState, BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      audioPlayerState is AudioPlayerPlaying
          ? IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 40,
              onPressed: () =>
                  context.read<AudioPlayerBloc>().add(PauseEvent()),
            )
          : IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 40,
              onPressed: () =>
                  context.read<AudioPlayerBloc>().add(ContinueEvent()),
            ),
      IconButton(
        icon: const Icon(Icons.skip_next),
        iconSize: 40,
        onPressed: () => context.read<AudioPlayerBloc>().add(NextEvent()),
      ),
    ],
  );
}
