import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayInfos extends StatelessWidget {
  const PlayInfos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
        builder: (context, state) {
      return Column(
        children: [
          Text(
            "sequence state: \n loop mode: ${state.sequenceState.loopMode} \n shuffleModeEnabled: ${state.sequenceState.shuffleModeEnabled}",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "playbackEventStream: \n ${state.playbackEvent.processingState}, \n updateTime=${state.playbackEvent.updateTime}, \n updatePosition=${state.playbackEvent.updatePosition}, \n bufferedPosition=${state.playbackEvent.bufferedPosition}, \n duration=${state.playbackEvent.duration}, \n currentIndex=${state.playbackEvent.currentIndex}",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "position stream: ${state.position}",
            textAlign: TextAlign.center,
          ),
        ],
      );
    });
  }
}
