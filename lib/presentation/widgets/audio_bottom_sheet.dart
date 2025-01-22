import 'package:lemon/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:lemon/logic/blocs/playlist_page/playlist_page_cubit.dart';
import 'package:lemon/presentation/screens/conditionalPages/audio_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioBottomSheet extends StatelessWidget {
  const AudioBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: _content(context),
        ));
  }
}

Widget _content(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: 3,

        /// build LinearProgressIndicator
        child: BlocConsumer<AudioPlayerBloc, AudioPlayerState>(
          listener: (context, state) {
            /// here, update SongProgress database
            context.read<PlaylistPageCubit>().playListCubitUpdateSongProgress(
              state.currentPlaylistId,
                state.playbackState.queueIndex ?? 0,
                state.playbackState.position.inMilliseconds);
          },
          builder: (context, state) {
            return LinearProgressIndicator(
              value: (state.mediaItem.duration != null &&
                      state.mediaItem.duration!.inSeconds > 0)
                  ? (state.playbackState.position.inSeconds /
                      state.mediaItem.duration!.inSeconds)
                  : 0,
            );
          },
        ),
      ),
      ListTile(
        /// build title
        title: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
          buildWhen: (prev, curr) =>
              prev.mediaItem.title != curr.mediaItem.title,
          builder: (context, state) {
            return Text(
              state.mediaItem.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),

        /// build trailing
        trailing: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
          buildWhen: (prev, curr) =>
              prev.playbackState.playing != curr.playbackState.playing,
          builder: (context, state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                state.playbackState.playing
                    ? IconButton(
                        icon: const Icon(Icons.pause_rounded),
                        iconSize: 40,
                        onPressed: () =>
                            context.read<AudioPlayerBloc>().add(PauseEvent()),
                      )
                    : IconButton(
                        icon: const Icon(Icons.play_arrow_rounded),
                        iconSize: 40,
                        onPressed: () => context
                            .read<AudioPlayerBloc>()
                            .add(ContinueEvent()),
                      ),
                IconButton(
                  icon: const Icon(Icons.fast_forward_rounded),
                  iconSize: 40,
                  onPressed: () =>
                      context.read<AudioPlayerBloc>().add(NextEvent()),
                ),
              ],
            );
          },
        ),
      )
    ],
  );
}
