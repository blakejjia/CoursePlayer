import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';

class PlayerButtonsBottomSheet extends StatelessWidget {
  const PlayerButtonsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Name of Song"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _playPauseButton(context),
          _nextButton(context),
        ],
      ),
    );
  }

  Widget _playPauseButton(BuildContext context) {
    final AudioPlayerState playerState = context.read<AudioPlayerBloc>().state;
    if (playerState is AudioPlayerPause) {
      // playing
      return IconButton(
        icon: const Icon(Icons.play_arrow),
        iconSize: 40,
        onPressed: () => context.read<AudioPlayerBloc>().add(ContinueEvent()),
      );
    } else {
      // not complete, not playing, not loading
      return IconButton(
        icon: const Icon(Icons.pause),
        iconSize: 40,
        onPressed: () => context.read<AudioPlayerBloc>().add(PauseEvent()),
      );
    }
  }

  Widget _nextButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.skip_next),
      iconSize: 40,
      onPressed: () => context.read<AudioPlayerBloc>().add(NextEvent()),
    );
  }
}
