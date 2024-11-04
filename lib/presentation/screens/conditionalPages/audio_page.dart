import 'package:course_player/presentation/widgets/play_infos.dart';
import 'package:course_player/presentation/widgets/player_buttons.dart';
import 'package:course_player/presentation/widgets/player_progress_bar.dart';
import 'package:flutter/material.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayInfos(),
          PlayerProgressBar(),
          PlayerButtons(),
        ],
      ),
    );
  }
}
