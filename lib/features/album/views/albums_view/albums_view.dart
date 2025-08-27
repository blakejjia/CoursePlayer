import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lemon/core/backEnd/data/models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:lemon/core/router/app_router.dart';
// Using providerContainer from main.dart for non-widget access
import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:lemon/main.dart';

part 'card_view.dart';
part 'list_view.dart';

class AlbumsView extends StatelessWidget {
  final bool isGridView;
  final List<Album> albums;
  final Map<dynamic, dynamic> info;
  const AlbumsView(
      {super.key,
      required this.isGridView,
      required this.albums,
      required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: (isGridView) ? _showInCard(albums) : _showInList(albums),
        ),
        _progressIndicator(context, info),
      ],
    );
  }
}

Widget _progressIndicator(BuildContext context, Map info) {
  if (info.containsKey("currentFolder") &&
      info["totalFolder"] != info["currentFolder"]) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "indexing: Folder ${info["currentFolder"]}/${info["totalFolder"]}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        LinearProgressIndicator(
          value: info["currentFolder"] / info["totalFolder"],
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
  final container = providerContainer;
  container.read(songListProvider.notifier).locateAlbum(album);
  // Navigate via go_router; extra carries typed data if needed later.
  context.goNamed('album', extra: AlbumRouteData(album));
}

String formatAlbumProgress(Album album) {
  int progress = (album.playedTracks * 100 / album.totalTracks).round();
  return "$progress%";
}
