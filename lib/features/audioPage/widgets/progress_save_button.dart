import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/audio/providers/audio_player_provider.dart';

/// A button widget that allows users to manually save playback progress
class ProgressSaveButton extends ConsumerWidget {
  const ProgressSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);

    if (state is! AudioPlayerIdeal) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.save),
      tooltip: 'Save Progress',
      onPressed: () async {
        final notifier = ref.read(audioPlayerProvider.notifier);
        await notifier.saveProgress();

        // Show confirmation
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Progress saved!'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
    );
  }
}
