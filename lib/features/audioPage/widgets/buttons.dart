part of '../audio_page.dart';

// Share button removed during migration for simplicity; re-add if needed.

class PlayerButtons extends ConsumerWidget {
  const PlayerButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    if (state is! AudioPlayerIdeal) {
      return const SizedBox.shrink();
    }
    return Row(
      spacing: 12.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _DocumentButton(),
        _PreviousButton(),
        _PlayPauseButton(),
        _NextButton(),
        _SpeedButton(),
      ],
    );
  }
}

class _PlayPauseButton extends ConsumerWidget {
  const _PlayPauseButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    if (state is! AudioPlayerIdeal) {
      return const SizedBox.shrink();
    }
    final isPlaying = state.playbackState.playing;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
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
          HapticFeedback.lightImpact();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 40.0,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _PreviousButton extends ConsumerWidget {
  const _PreviousButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.skip_previous_rounded,
          size: 40, color: Theme.of(context).colorScheme.onSurface),
      onPressed: () {
        ref.read(audioPlayerProvider.notifier).previous();
        HapticFeedback.lightImpact();
      },
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.skip_next_rounded,
          size: 40, color: Theme.of(context).colorScheme.onSurface),
      onPressed: () {
        ref.read(audioPlayerProvider.notifier).next();
        HapticFeedback.lightImpact();
      },
    );
  }
}

class _SpeedButton extends ConsumerWidget {
  const _SpeedButton();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    if (state is! AudioPlayerIdeal) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: Icon(Icons.speed_outlined, size: 32),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          useSafeArea: true,
          builder: (context) => SpeedSelectionBS(
            initialSpeed: state.playbackState.speed,
            onSpeedSelected: (newSpeed, applyToAlbum) async {
              await ref.read(audioPlayerProvider.notifier).setSpeed(newSpeed);
              if (applyToAlbum) {
                await ref.read(albumRepositoryProvider).updateAlbumPlaySpeed(
                      state.mediaItem.album!,
                      newSpeed,
                    );
              }
            },
          ),
        );
      },
    );
  }
}

class _DocumentButton extends ConsumerWidget {
  const _DocumentButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    if (state is! AudioPlayerIdeal) {
      return const SizedBox.shrink();
    }
    return IconButton(
      icon: Icon(Icons.description_outlined,
          size: 32, color: Theme.of(context).colorScheme.onSurface),
      onPressed: () {
        // Handle document button press
      },
    );
  }
}
