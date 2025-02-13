import 'package:lemon/common/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../audioCore/bloc/audio_player_bloc.dart';
import 'widgets/albums_widgets.dart';
import 'bloc/album_page_cubit.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

/// [AlbumPage] is the page to display all playlists
/// reason why is stateful, just to use the refresh indicator
/// makes app feels reliable.
/// Program doesn't rely on that.
class _AlbumPageState extends State<AlbumPage> {
  @override
  void initState() {
    context.read<AlbumPageCubit>().load();
    super.initState();
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
                        return Text(
                            state.isGridView ? 'list view' : 'grid view');
                      },
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: BlocBuilder<AlbumPageCubit, AlbumPageState>(
              // do not reload if play history changes
              buildWhen: (prev, curr) => (prev.isGridView != curr.isGridView ||
                  prev.albums != curr.albums),
              builder: (BuildContext context, AlbumPageState state) {
                return state.isGridView
                    ? _showInCard(state.albums)
                    : _showInList(state.albums);
              }),
        ));
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  void _continueWithHistory(BuildContext context) {
    LatestPlayed? playHistory =
        context.read<AlbumPageCubit>().state.latestPlayed;
    if (playHistory != null) {
      context
          .read<AudioPlayerBloc>()
          .add(LocateAudio(playHistory.album, playHistory.songId));
    }
  }
}

Widget _showInCard(List<Album> albums) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 设置2列
    ),
    itemCount: albums.length, // Playlist数量
    itemBuilder: (context, index) {
      final playlist = albums[index];
      return AlbumCard(album: playlist);
    },
  );
}

Widget _showInList(List<Album> albums) {
  return ListView.builder(
    itemCount: albums.length,
    itemBuilder: (context, index) {
      return AlbumTile(albums[index]);
    },
  );
}
