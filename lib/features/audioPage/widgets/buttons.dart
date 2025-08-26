part of '../audio_page.dart';

Widget _shareButton(AudioPlayerIdeal state, BuildContext context) {
  return IconButton.filled(
    style: IconButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
    ),
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
  final isPlaying = state.playbackState.playing;
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    curve: Curves.linear,
    decoration: ShapeDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: isPlaying
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            )
          : const CircleBorder(),
    ),
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<AudioPlayerBloc>().add(
              isPlaying ? PauseEvent() : ContinueEvent(),
            );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: 50.0,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    ),
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
    icon: Icon(Icons.skip_previous_rounded,
        size: 40, color: Theme.of(context).colorScheme.onSurface),
    onPressed: () => context.read<AudioPlayerBloc>().add(PreviousEvent()),
  );
}

Widget _nextButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.skip_next_rounded,
        size: 40, color: Theme.of(context).colorScheme.onSurface),
    onPressed: () => context.read<AudioPlayerBloc>().add(NextEvent()),
  );
}
