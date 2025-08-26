import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/providers/audio_player_provider.dart';

part 'widgets/buttons.dart';
part 'widgets/progress_indicator.dart';

/// AudioPage now uses Riverpod to read the player state
/// and passes it down to its children.
class AudioPage extends ConsumerWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    if (state is AudioPlayerIdeal) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _playInfos(context, state),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PlayerProgressBar(state: state),
            ),
            PlayerButtons(state: state),
          ],
        ),
      );
    } else {
      return const Center(child: Text("no play data"));
    }
  }
}

/// [_playInfos] now receives the state directly.
Widget _playInfos(BuildContext context, AudioPlayerIdeal state) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Text(
      state.mediaItem.title,
      style: Theme.of(context).textTheme.titleMedium,
    ),
  );
}

/// [PlayerButtons] now accepts the [AudioPlayerState] as a parameter.
class PlayerButtons extends ConsumerWidget {
  final AudioPlayerIdeal state;
  const PlayerButtons({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        // _replay10Button(context),
        _previousButton(context, ref),
        _playPauseButton(context, state, ref),
        _nextButton(context, ref),
        // _speedButton(state, context),
        // _shareButton(state, context),
      ],
    );
  }
}
