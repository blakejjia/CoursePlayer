import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/providers/load_from_db.dart';
import 'package:lemon/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/logic/bloc/audio_player/audio_player_bloc.dart';
import '../../audioPage/presentation/future_builder.dart';
import '../../common/widgets/playlist_widgets.dart';
import 'bloc/album_page_cubit.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
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
                context.read<AlbumPageCubit>().playListPageChangeView();
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'ListView',
                    child: BlocBuilder<AlbumPageCubit, AlbumPageState>(
                      buildWhen: (prev, curr) =>
                          prev.isGridView != curr.isGridView,
                      builder: (context, state) {
                        return Text(state.isGridView ? 'list view' : 'grid view');
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
                return const Center(child: Text("please rebuild index in settings page"));
              } else {
                return BlocBuilder<AlbumPageCubit, AlbumPageState>(
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
        context.read<AlbumPageCubit>().state.latestPlayed;
    context
        .read<AudioPlayerBloc>()
        .add(LocateAudio(playHistory?[0], playHistory?[1], playHistory?[2]));
  }
}

Widget _showInCard(List<Album> playlists) {
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

Widget _showInList(List<Album> playlists) {
  return ListView.builder(
    itemCount: playlists.length,
    itemBuilder: (context, index) {
      return PlaylistList(playlists[index]);
    },
  );
}
