import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'audio_page.dart';
import '../../core/audio/providers/audio_player_provider.dart';

class AudioBottomSheet extends ConsumerWidget {
  const AudioBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    if (state is! AudioPlayerIdeal) return const SizedBox.shrink();

    final duration = state.mediaItem.duration;
    final progress = (duration != null && duration.inSeconds > 0)
        ? state.playbackState.position.inSeconds / duration.inSeconds
        : 0.0;

    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => Container(
          alignment: Alignment.center,
          child: const AudioPage(),
        ),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        height: 71,
        child: Column(
          children: [
            SizedBox(
              height: 3,
              child: LinearProgressIndicator(value: progress),
            ),
            ListTile(
              title: Text(
                state.mediaItem.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      state.playbackState.playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    iconSize: 40,
                    onPressed: () {
                      final notifier = ref.read(audioPlayerProvider.notifier);
                      state.playbackState.playing
                          ? notifier.pause()
                          : notifier.play();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.fast_forward_rounded),
                    iconSize: 40,
                    onPressed: () =>
                        ref.read(audioPlayerProvider.notifier).next(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
