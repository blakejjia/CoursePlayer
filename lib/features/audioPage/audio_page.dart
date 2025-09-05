import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/audioPage/utils/time_formatter.dart';
import 'package:lemon/main.dart';

import '../../core/audio/providers/audio/audio_player_provider.dart';
import 'widgets/speed_selection_bs.dart';

part 'widgets/buttons.dart';
part 'widgets/progress_indicator.dart';

/// AudioPage now uses Riverpod to read the player state
/// and passes it down to its children.
class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _PlayInfos(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const PlayerProgressBar(),
          ),
          const PlayerButtons(),
        ],
      ),
    );
  }
}

/// [_PlayInfos] is now a ConsumerWidget and reads the provider itself.
class _PlayInfos extends ConsumerWidget {
  const _PlayInfos();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    if (state is AudioPlayerIdeal) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Text(
          state.mediaItem.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
