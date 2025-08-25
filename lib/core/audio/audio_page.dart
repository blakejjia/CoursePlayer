import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'bloc/audio_player_bloc.dart';

/// AudioPage now builds with a single BlocBuilder and passes the state
/// down to its children.
class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        if (state is AudioPlayerIdeal) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _playInfos(context, state),
                PlayerProgressBar(state: state),
                PlayerButtons(state: state),
              ],
            ),
          );
        } else {
          return Center(child: Text("no play data"));
        }
      },
    );
  }
}

/// [_playInfos] now receives the state directly.
Widget _playInfos(BuildContext context, AudioPlayerIdeal state) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Text(
      state.mediaItem.title,
      style: Theme.of(context).textTheme.titleMedium,
    ),
  );
}

/// [PlayerButtons] now accepts the [AudioPlayerState] as a parameter.
class PlayerButtons extends StatelessWidget {
  final AudioPlayerIdeal state;
  const PlayerButtons({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _replay10Button(context),
        _previousButton(context),
        _playPauseButton(state, context),
        _nextButton(context),
        _speedButton(state, context),
        _shareButton(state, context),
      ],
    );
  }

  Widget _shareButton(AudioPlayerIdeal state, BuildContext context) {
    return IconButton(
      onPressed: () {
        if (state.mediaItem.displayDescription == null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("找不到要分享的内容"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("确定"),
                  ),
                ],
              );
            },
          );
        } else {
          Share.shareXFiles(
            [XFile(state.mediaItem.displayDescription!)],
          );
        }
      },
      icon: const Icon(Icons.ios_share_rounded, size: 30),
    );
  }

  Widget _playPauseButton(AudioPlayerIdeal state, BuildContext context) {
    return IconButton(
      icon: Icon(
        state.playbackState.playing
            ? Icons.pause_rounded
            : Icons.play_arrow_rounded,
      ),
      iconSize: 64.0,
      onPressed: () {
        context.read<AudioPlayerBloc>().add(
              state.playbackState.playing ? PauseEvent() : ContinueEvent(),
            );
      },
    );
  }

  Widget _replay10Button(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<AudioPlayerBloc>().add(Rewind()),
      icon: const Icon(Icons.replay_10_rounded, size: 30),
    );
  }

  Widget _speedButton(AudioPlayerIdeal state, BuildContext context) {
    return InkWell(
      onTap: () => context
          .read<AudioPlayerBloc>()
          .add(SetSpeed(state.playbackState.speed)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Icon(Icons.speed_rounded, size: 24),
            Text(state.playbackState.speed.toString()),
          ],
        ),
      ),
    );
  }

  Widget _previousButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.fast_rewind_rounded, size: 40),
      onPressed: () => context.read<AudioPlayerBloc>().add(PreviousEvent()),
    );
  }

  Widget _nextButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.fast_forward_rounded, size: 40),
      onPressed: () => context.read<AudioPlayerBloc>().add(NextEvent()),
    );
  }
}

/// [PlayerProgressBar] now accepts the [AudioPlayerState] as a parameter.
class PlayerProgressBar extends StatelessWidget {
  final AudioPlayerIdeal state;
  const PlayerProgressBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.8 * MediaQuery.of(context).size.width,
      child: ProgressBar(
        progress: state.playbackState.position,
        buffered: state.playbackState.bufferedPosition,
        total: state.mediaItem.duration ?? Duration.zero,
        onSeek: (newPosition) =>
            context.read<AudioPlayerBloc>().add(SeekToPosition(newPosition)),
      ),
    );
  }
}
