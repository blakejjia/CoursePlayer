part of '../audio_page.dart';

class PlayerProgressBar extends StatefulWidget {
  final AudioPlayerIdeal state;
  const PlayerProgressBar({super.key, required this.state});

  @override
  State<PlayerProgressBar> createState() => _PlayerProgressBarState();
}

class _PlayerProgressBarState extends State<PlayerProgressBar> {
  double? _dragValueMs; // transient slider value while dragging (in ms)

  @override
  Widget build(BuildContext context) {
    final total = widget.state.mediaItem.duration ?? Duration.zero;
    final totalMs = total.inMilliseconds <= 0 ? 1 : total.inMilliseconds;

    final positionMs =
        widget.state.playbackState.position.inMilliseconds.clamp(0, totalMs);
    final bufferedMs = widget
        .state.playbackState.bufferedPosition.inMilliseconds
        .clamp(0, totalMs);

    final sliderValue = (_dragValueMs ?? positionMs).toDouble();
    final bufferedRatio = totalMs == 0 ? 0.0 : bufferedMs / totalMs;

    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Buffered bar in the background
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: bufferedRatio.clamp(0.0, 1.0),
            minHeight: 4,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.onSurface.withOpacity(0.25),
            ),
          ),
        ),
        // Foreground slider for current position and scrubbing
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
          ),
          child: Slider(
            value: sliderValue,
            min: 0,
            max: totalMs.toDouble(),
            onChanged: (v) {
              setState(() => _dragValueMs = v);
            },
            onChangeEnd: (v) {
              // Commit seek only when user releases the thumb
              final ref = ProviderScope.containerOf(context);
              ref
                  .read(audioPlayerProvider.notifier)
                  .seekTo(Duration(milliseconds: v.round()));
              setState(() => _dragValueMs = null);
            },
          ),
        ),
      ],
    );
  }
}
