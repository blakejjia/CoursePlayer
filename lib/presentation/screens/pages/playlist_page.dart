import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/providers/load_from_db.dart';
import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:course_player/logic/blocs/playlist_page/playlist_page_cubit.dart';
import 'package:course_player/presentation/widgets/future_builder.dart';
import 'package:course_player/presentation/widgets/playlist_widgets.dart';
import 'package:course_player/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            onPressed: () async {
              List<int>? playHistory =
                  context.read<PlaylistPageCubit>().state.latestPlayed;
              if (playHistory == null) return;
              List<Song>? songs = await getIt<LoadFromDb>()
                  .getSongsByPlaylistId(playHistory[0]);
              context
                  .read<AudioPlayerBloc>()
                  .add(LocateAudio(playHistory[1], songs, playHistory[2]));
            },
          ),
          actions: [
            BlocBuilder<PlaylistPageCubit, PlaylistPageState>(
              builder: (context, state) {
                return PopupMenuButton<String>(
                  onSelected: (selection) {
                    context.read<PlaylistPageCubit>().playListPageChangeView();
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'ListView',
                        child: Text(state.isGridView ? '显示为列表' : '显示为网格'),
                      ),
                    ];
                  },
                );
              },
            ),
          ],
        ),
        body: MRefreshFutureBuilder(
            //TODO:转移进bloc
            _refreshData,
            () => getIt<LoadFromDb>().getAllPlaylists(), child: (data) {
          return CourseList(data);
        }));
  }
}

class CourseList extends StatelessWidget {
  final List<Playlist>? playlists;
  const CourseList(this.playlists, {super.key});

  @override
  Widget build(BuildContext context) {
    if (playlists == null || playlists!.isEmpty) {
      return const Center(child: Text("空空如也,请在settings中重构索引"));
    } else {
      return Column(children: [
        Text(
          "Courses",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(
            child: BlocBuilder<PlaylistPageCubit, PlaylistPageState>(
                buildWhen: (prev, current) =>
                    prev.isGridView != current.isGridView,
                builder: (context, state) {
                  return state.isGridView
                      ? _showInCard(playlists!)
                      : _showInList(playlists!);
                })),
      ]);
    }
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
