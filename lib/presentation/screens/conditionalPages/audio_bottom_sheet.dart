import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:course_player/presentation/screens/conditionalPages/audio_page.dart';
import 'package:course_player/presentation/widgets/player_buttons_bottom_sheet.dart';
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
        height: 75,
        child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
          builder: (context, state) {
            return Column(
              children: [
                ...switch (state) {
                  AudioPlayerInitial() => [const Text("hello")], //TODO: remove this
                  AudioPlayerPlaying() || AudioPlayerPause() => [
                      SizedBox(
                        height: 3,
                        child: LinearProgressIndicator(
                          value: (state.position.inSeconds /
                              state.totalTime.inSeconds),
                        ),
                      ),
                      const PlayerButtonsBottomSheet(),
                    ],
                }
              ],
            );
          },
        ),
      ),
    );
  }
}
