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
        Stack(
          children: [
            // ========== The slider ======================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Slider(
                value:
                    _dragMs != -1 ? _dragMs.toDouble() : currentMs.toDouble(),
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
            ),
            // ===== buttons ========
            Row(
              children: [
                // -10s button (fixed size, no unconstrained expansion)
                IconButton(
                  icon: const Icon(Icons.replay_10_outlined),
                  onPressed: () {
                    final newPosition = state.playbackState.position -
                        const Duration(seconds: 10);
                    ref.read(audioPlayerProvider.notifier).seekTo(newPosition);
                  },
                  iconSize: 32,
                ),
                Expanded(
                  child: Container(),
                ),
                // +10s button (constrained to avoid IconButton's default min size)
                IconButton(
                  icon: const Icon(Icons.forward_10_outlined),
                  onPressed: () {
                    final newPosition = state.playbackState.position +
                        const Duration(seconds: 10);
                    ref.read(audioPlayerProvider.notifier).seekTo(newPosition);
                  },
                  iconSize: 32,
                ),
              ],
            ),
          ],
        ),

        // The time indicators ======================
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                formatDuration(Duration(
                    milliseconds: _dragMs != -1 ? _dragMs : currentMs)),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                formatDuration(Duration(milliseconds: totalMs)),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }
}
