part of '../audio_page.dart';

// Share button removed during migration for simplicity; re-add if needed.

Widget _playPauseButton(
    BuildContext context, AudioPlayerIdeal state, WidgetRef ref) {
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
        final notifier = ref.read(audioPlayerProvider.notifier);
        isPlaying ? notifier.pause() : notifier.play();
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

// Unused optional controls (share, rewind, speed) were removed during migration.

Widget _previousButton(BuildContext context, WidgetRef ref) {
  return IconButton(
    icon: Icon(Icons.skip_previous_rounded,
        size: 40, color: Theme.of(context).colorScheme.onSurface),
    onPressed: () => ref.read(audioPlayerProvider.notifier).previous(),
  );
}

Widget _nextButton(BuildContext context, WidgetRef ref) {
  return IconButton(
    icon: Icon(Icons.skip_next_rounded,
        size: 40, color: Theme.of(context).colorScheme.onSurface),
    onPressed: () => ref.read(audioPlayerProvider.notifier).next(),
  );
}
