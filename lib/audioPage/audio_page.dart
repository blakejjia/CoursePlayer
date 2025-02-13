import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../audioCore/bloc/audio_player_bloc.dart';


/// [AudioPage] is a page that displays the audio player state.
///
/// It displays the title of the current media item, a progress bar, and buttons
/// to control the playback.
class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _playInfos(context),
          PlayerProgressBar(),
          PlayerButtons(),
        ],
      ),
    );
  }
}

Widget _playInfos(BuildContext context) {
  // TODO: shouldn't rely on AudioPlayerBloc
  return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
    buildWhen: (prev, curr) => prev.mediaItem != curr.mediaItem,
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          state.mediaItem.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    },
  );
}

/// [PlayerButtons] is a row of buttons to control the audio player.
///
/// It contains buttons to:
/// - replay 10 seconds
/// - go to the previous media item
/// - play/pause the current media item
/// - go to the next media item
/// - change the playback speed
/// - share the current media item
class PlayerButtons extends StatelessWidget {
  const PlayerButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      buildWhen: (prev, current) =>
          prev.playbackState.speed != current.playbackState.speed ||
          prev.playbackState.playing != current.playbackState.playing,
      builder: (context, state) {
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
      },
    );
  }

  Widget _shareButton(AudioPlayerState state, BuildContext context) {
    return IconButton(
      onPressed: () {
        if (state.mediaItem.displayDescription == null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("找不到要分享的内容"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("确定"),
                  ),
                ],
              );
            },
          );
        } else {
          Share.shareXFiles([XFile(state.mediaItem.displayDescription!)]);
        }
      },
      icon: const Icon(Icons.ios_share_rounded, size: 30),
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
    return InkWell(
      onTap: () => context
          .read<AudioPlayerBloc>()
          .add(SetSpeed(state.playbackState.speed)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Icon(
              Icons.speed_rounded,
              size: 24,
            ),
            Text(state.playbackState.speed.toString()),
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
        buildWhen: (prev, curr) =>
            prev.playbackState.updatePosition != curr.playbackState.updatePosition,
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
