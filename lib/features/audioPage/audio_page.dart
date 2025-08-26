import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/audio/bloc/audio_player_bloc.dart';

part 'widgets/buttons.dart';
part 'widgets/progress_indicator.dart';

/// AudioPage now builds with a single BlocBuilder and passes the state
/// down to its children.
class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
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
          return Center(child: Text("no play data"));
        }
      },
    );
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
class PlayerButtons extends StatelessWidget {
  final AudioPlayerIdeal state;
  const PlayerButtons({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        // _replay10Button(context),
        _previousButton(context),
        _playPauseButton(state, context),
        _nextButton(context),
        // _speedButton(state, context),
        // _shareButton(state, context),
      ],
    );
  }
}
