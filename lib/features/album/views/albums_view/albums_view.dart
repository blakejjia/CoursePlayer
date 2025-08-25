import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lemon/core/backEnd/data/models/models.dart';
import 'package:lemon/core/backEnd/data/repositories/covers_repository.dart';
import 'package:lemon/features/album/bloc/album_page_cubit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:lemon/features/playList/songs_list_page.dart';
import 'package:lemon/main.dart';

part 'card_view.dart';
part 'list_view.dart';

class AlbumsView extends StatelessWidget {
  final AlbumPageIdeal state;
  const AlbumsView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: (state.isGridView)
              ? _showInCard(state.albums)
              : _showInList(state.albums),
        ),
        _progressIndicator(context, state),
      ],
    );
  }
}

Widget _progressIndicator(BuildContext context, AlbumPageIdeal state) {
  if (state.info.containsKey("currentFolder") &&
      state.info["totalFolder"] != state.info["currentFolder"]) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "indexing: Folder ${state.info["currentFolder"]}/${state.info["totalFolder"]}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        LinearProgressIndicator(
          value: state.info["currentFolder"] / state.info["totalFolder"],
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ],
    );
  }
  return const SizedBox.shrink();
}

void _navigateToSongsListPage(BuildContext context, Album album) {
  // initialize riverpod provider
  final container = getIt<ProviderContainer>();
  container.read(songListProvider.notifier).locateAlbum(album);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SongsListPage(),
    ),
  );
}

String formatAlbumProgress(Album album) {
  int progress = (album.playedTracks * 100 / album.totalTracks).round();
  return "$progress%";
}
