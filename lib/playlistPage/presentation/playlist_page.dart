import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/providers/load_from_db.dart';
import 'package:lemon/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/logic/bloc/audio_player/audio_player_bloc.dart';
import '../bloc/playlist_page/playlist_page_cubit.dart';
import '../../audioPage/presentation/future_builder.dart';
import 'widgets/playlist_widgets.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Courser'),
          leading: IconButton(
            icon: Icon(Icons.play_circle_filled),
            onPressed: () {
              _continueWithHistory(context);
            },
          ),
          actions: [
            // change view button
            PopupMenuButton<String>(
              onSelected: (_) {
                context.read<PlaylistPageCubit>().playListPageChangeView();
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'ListView',
                    child: BlocBuilder<PlaylistPageCubit, PlaylistPageState>(
                      buildWhen: (prev, curr) =>
                          prev.isGridView != curr.isGridView,
                      builder: (context, state) {
                        return Text(state.isGridView ? '显示为列表' : '显示为网格');
                      },
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: MRefreshFutureBuilder(
            _refreshData, () => getIt<LoadFromDb>().getAllPlaylists(),
            child: (playlist) {
              if (playlist == null || playlist.isEmpty) {
                return const Center(child: Text("空空如也,请在settings中重构索引"));
              } else {
                return BlocBuilder<PlaylistPageCubit, PlaylistPageState>(
                    buildWhen: (prev, curr) => prev.isGridView != curr.isGridView,
                    builder: (context, state) {
                      return state.isGridView
                          ? _showInCard(playlist)
                          : _showInList(playlist);
                    });
              }
        }));
  }

  void _continueWithHistory(BuildContext context) {
    List<int>? playHistory =
        context.read<PlaylistPageCubit>().state.latestPlayed;
    context
        .read<AudioPlayerBloc>()
        .add(LocateAudio(playHistory?[0], playHistory?[1], playHistory?[2]));
  }
}

Widget _showInCard(List<Playlist> playlists) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 设置2列
    ),
    itemCount: playlists.length, // Playlist数量
    itemBuilder: (context, index) {
      final playlist = playlists[index];
      return PlaylistCard(playList: playlist);
    },
  );
}

Widget _showInList(List<Playlist> playlists) {
  return ListView.builder(
    itemCount: playlists.length,
    itemBuilder: (context, index) {
      return PlaylistList(playlists[index]);
    },
  );
}
