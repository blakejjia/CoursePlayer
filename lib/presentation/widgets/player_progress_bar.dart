import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.8 * MediaQuery.of(context).size.width,
      child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
        builder: (context, state) {
          return ProgressBar(
            progress: state.position,
            buffered: state.playbackEvent.bufferedPosition,
            total: state.totalTime,
            onSeek: (newPosition) => context
                .read<AudioPlayerBloc>()
                .add(SeekToPosition(newPosition)),
          );
        },
      ),
    );
  }
}
