
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayInfos(),
          PlayerProgressBar(),
          PlayerButtons(),
        ],
      ),
    );
  }
}


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


class PlayerButtons extends StatelessWidget {
  const PlayerButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _shuffleButton(state, context),
            _previousButton(context),
            _playPauseButton(state, context),
            _nextButton(context),
            _repeatButton(state, context),
          ],
        );
      },
    );
  }

  Widget _playPauseButton(AudioPlayerState playerState, BuildContext context) {
    final processingState = playerState.playbackEvent.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      // not ready but loading
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 64.0,
        height: 64.0,
        child: const CircularProgressIndicator(),
      );
    } else if (playerState is AudioPlayerPause) {
      // playing
      return IconButton(
        icon: const Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: () => context.read<AudioPlayerBloc>().add(ContinueEvent()),
      );
    } else if (processingState != ProcessingState.completed) {
      // not complete, not playing, not loading
      return IconButton(
        icon: const Icon(Icons.pause),
        iconSize: 64.0,
        onPressed: () => context.read<AudioPlayerBloc>().add(PauseEvent()),
      );
    } else {
      // complete
      return IconButton(
        icon: const Icon(Icons.replay),
        iconSize: 64.0,
        onPressed: () =>
            context.read<AudioPlayerBloc>().add(FinishedEvent()), // TODO:改掉
        // onPressed: () => audioPlayer.seek(Duration.zero,
        //     index: audioPlayer.effectiveIndices?.first),
      );
    }
  }

  Widget _shuffleButton(AudioPlayerState state, BuildContext context) {
    return IconButton(
      icon: state.sequenceState.shuffleModeEnabled
          ? Icon(Icons.shuffle,
          color: Theme.of(context).colorScheme.primaryFixed)
          : const Icon(Icons.shuffle),
      onPressed: () => context.read<AudioPlayerBloc>().add(NextShuffleMode()),
    );
  }

  Widget _previousButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.skip_previous),
      onPressed: () => context.read<AudioPlayerBloc>().add(PreviousEvent()),
    );
  }

  Widget _nextButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.skip_next),
      onPressed: () => context.read<AudioPlayerBloc>().add(NextEvent()),
    );
  }

  Widget _repeatButton(AudioPlayerState state, BuildContext context) {
    // context.read<AudioPlayerBloc>().add(NextLoopMode());
    return switch (state.sequenceState.loopMode) {
      LoopMode.off => IconButton(
          icon: const Icon(Icons.repeat),
          onPressed: () => context.read<AudioPlayerBloc>().add(NextLoopMode())),
      LoopMode.one => IconButton(
        icon: Icon(Icons.repeat_one,
            color: Theme.of(context).colorScheme.primaryFixed),
        onPressed: () => context.read<AudioPlayerBloc>().add(NextLoopMode()),
      ),
      LoopMode.all => IconButton(
        icon: Icon(Icons.repeat,
            color: Theme.of(context).colorScheme.primaryFixed),
        onPressed: () => context.read<AudioPlayerBloc>().add(NextLoopMode()),
      ),
    };
  }
}


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
