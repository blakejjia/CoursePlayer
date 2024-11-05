import 'package:course_player/logic/blocs/audio_info/audio_info_bloc.dart';
import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:course_player/presentation/screens/conditionalPages/audio_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioBottomSheet extends StatelessWidget {
  const AudioBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        backgroundColor: Colors.amber,
        context: context,
        isScrollControlled: true, // 让 BottomSheet 覆盖整个屏幕
        builder: (ctx) => Container(
          color: Colors.white54,
          alignment: Alignment.center,
          child: const AudioPage(),
        ),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        height: 71,
        child: _bottomSheet(context),
      ),
    );
  }
}

Widget _bottomSheet(BuildContext context) {
  return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
    builder: (context, state) {
      return Column(
        children: [
          ...switch (state) {
            AudioPlayerInitial() => [const Text("hello")], //TODO: remove this
            AudioPlayerPlaying() || AudioPlayerPause() => [
                SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: (state.totalTime.inSeconds > 0)
                        ? (state.position.inSeconds / state.totalTime.inSeconds)
                        : 0,
                  ),
                ),
                ListTile(
                  title: BlocBuilder<AudioInfoBloc, AudioInfoState>(
                    builder: (context, state) {
                      return Text(state.buffer[state.index]?.title ?? "",
                          maxLines: 2, overflow: TextOverflow.ellipsis);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      state is AudioPlayerPlaying
                          ? IconButton(
                              icon: const Icon(Icons.pause),
                              iconSize: 40,
                              onPressed: () => context
                                  .read<AudioPlayerBloc>()
                                  .add(PauseEvent()),
                            )
                          : IconButton(
                              icon: const Icon(Icons.play_arrow),
                              iconSize: 40,
                              onPressed: () => context
                                  .read<AudioPlayerBloc>()
                                  .add(ContinueEvent()),
                            ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        iconSize: 40,
                        onPressed: () =>
                            context.read<AudioPlayerBloc>().add(NextEvent()),
                      ),
                    ],
                  ),
                )
              ],
          }
        ],
      );
    },
  );
}
