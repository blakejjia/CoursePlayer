import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:course_player/logic/blocs/audio_info/audio_info_bloc.dart';
import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<AudioInfoBloc, AudioInfoState>(
        builder: (context, state) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              (state as AudioInfoSong).song.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
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
      buildWhen: (prev, current) {
        if (prev.playbackState.speed != current.playbackState.speed ||
            prev.playbackState.playing != current.playbackState.playing) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _replay10Button(context),
            _previousButton(context),
            _playPauseButton(state, context),
            _nextButton(context),
            _speedButton(state, context),
          ],
        );
      },
    );
  }

  Widget _playPauseButton(AudioPlayerState state, BuildContext context) {
    if (state.playbackState.playing) {
      return IconButton(
        icon: const Icon(Icons.pause_rounded),
        iconSize: 64.0,
        onPressed: () => context.read<AudioPlayerBloc>().add(PauseEvent()),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.play_arrow_rounded),
        iconSize: 64.0,
        onPressed: () => context.read<AudioPlayerBloc>().add(ContinueEvent()),
      );
    }
  }

  Widget _replay10Button(BuildContext context) {
    return IconButton(
        onPressed: () => context.read<AudioPlayerBloc>().add(Rewind()),
        icon: const Icon(
          Icons.replay_10_rounded,
          size: 30,
        ));
  }

  Widget _speedButton(AudioPlayerState state, BuildContext context) {
    //TODO: 逻辑放到bloc里面！
    double currentSpeed = state.playbackState.speed;
    List<double> speedOptions = [1.0, 1.5, 1.7, 1.8, 2.0];
    int currentIndex = speedOptions.indexOf(currentSpeed);
    double proposedSpeed =
        speedOptions[(currentIndex + 1) % speedOptions.length];

    return InkWell(
      onTap: () => context.read<AudioPlayerBloc>().add(SetSpeed(proposedSpeed)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Icon(
              Icons.speed_rounded,
              size: 24,
            ),
            Text(currentSpeed.toString()),
          ],
        ),
      ),
    );
  }

  Widget _previousButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.fast_rewind_rounded,
        size: 40,
      ),
      onPressed: () => context.read<AudioPlayerBloc>().add(PreviousEvent()),
    );
  }

  Widget _nextButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.fast_forward_rounded,
        size: 40,
      ),
      onPressed: () => context.read<AudioPlayerBloc>().add(NextEvent()),
    );
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
            progress: state.playbackState.position,
            buffered: state.playbackState.bufferedPosition,
            total: state.mediaItem.duration ?? Duration.zero,
            onSeek: (newPosition) => context
                .read<AudioPlayerBloc>()
                .add(SeekToPosition(newPosition)),
          );
        },
      ),
    );
  }
}
