part of '../audio_page.dart';

class PlayerProgressBar extends ConsumerStatefulWidget {
  const PlayerProgressBar({super.key});

  @override
  ConsumerState<PlayerProgressBar> createState() => _PlayerProgressBarState();
}

class _PlayerProgressBarState extends ConsumerState<PlayerProgressBar> {
  int _dragMs = -1;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(audioPlayerProvider);
    if (state is! AudioPlayerIdeal) {
      return const SizedBox.shrink();
    }
    final totalMs = state.mediaItem.duration?.inMilliseconds ?? 0;
    final bufferedMs = state.playbackState.bufferedPosition.inMilliseconds
        .clamp(0, totalMs)
        .toDouble();
    final currentMs =
        state.playbackState.position.inMilliseconds.clamp(0, totalMs);

    return Column(
      children: [
        // The slider ======================
        Slider(
          value: _dragMs != -1 ? _dragMs.toDouble() : currentMs.toDouble(),
          secondaryTrackValue: bufferedMs,
          min: 0,
          max: totalMs.toDouble(),
          onChanged: (v) {
            setState(() {
              _dragMs = v.round();
            });
          },
          onChangeEnd: (v) {
            ref
                .read(audioPlayerProvider.notifier)
                .seekTo(Duration(milliseconds: v.round()));
            setState(() {
              _dragMs = -1;
            });
          },
        ),

        // The time indicators ======================
        Row(
          children: [
            Text(
              formatDuration(
                  Duration(milliseconds: _dragMs != -1 ? _dragMs : currentMs)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Expanded(child: Container()),
            Text(
              formatDuration(Duration(milliseconds: totalMs)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        )
      ],
    );
  }
}
