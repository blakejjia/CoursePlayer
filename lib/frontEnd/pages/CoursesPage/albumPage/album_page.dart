import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemon/frontEnd/pages/CoursesPage/albumPage/views/albums_view/albums_view.dart';
import 'package:lemon/frontEnd/pages/CoursesPage/albumPage/views/loading_view.dart';
import 'package:lemon/frontEnd/pages/CoursesPage/albumPage/views/welcom_view.dart';
import 'package:lemon/frontEnd/pages/settingsPage/bloc/settings_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../audioCore/bloc/audio_player_bloc.dart';
import 'bloc/album_page_cubit.dart';

part './views/blank_view.dart';

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
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumPageCubit, AlbumPageState>(
      buildWhen: (previous, current) =>
          previous.latestPlayed == current.latestPlayed,
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Courser'),
              leading: IconButton(
                icon: Icon(Icons.play_circle_filled),
                onPressed: () {
                  _continueWithHistory(state);
                },
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (_) {
                    context.read<AlbumPageCubit>().playListPageChangeView();
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                          value: 'ListView',
                          child: Text(
                              (state is AlbumPageIdeal && state.isGridView)
                                  ? 'list view'
                                  : 'grid view')),
                    ];
                  },
                ),
              ],
            ),
            body: RefreshIndicator(
                onRefresh: _refreshData,
                child: (state is AlbumPageIdeal)
                    ? (state.albums.isEmpty ? BlankView() : AlbumsView(state))
                    : (state is AlbumPageLoading
                        ? LoadingView()
                        : BlankView())));
      },
    );
  }

  Future<void> _refreshData() async {
    context.read<AlbumPageCubit>().load();
  }

  void _continueWithHistory(AlbumPageState state) {
    final playHistory = state.latestPlayed;
    if (playHistory != null) {
      context
          .read<AudioPlayerBloc>()
          .add(LocateAudio(playHistory.album, playHistory.songId));
    }
  }
}
