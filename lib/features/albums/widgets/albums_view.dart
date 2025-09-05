import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/data/models/models.dart';
// Uses the nearest ProviderScope container to dispatch actions
import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lemon/core/router/app_router.dart';

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
  // Use the nearest ProviderScope's container to avoid global container mismatch
  final container = ProviderScope.containerOf(context, listen: false);
  container.read(songListProvider.notifier).locateAlbum(album);
  // Navigate via go_router; extra carries typed data if needed later.
  context.pushNamed('album', extra: AlbumRouteData(album));
}

String formatAlbumProgress(Album album) {
  final played = album.playedTrackNum ?? 0;
  final total = album.totalTrackNum == 0 ? 1 : album.totalTrackNum;
  int progress = (played * 100 / total).round();
  return "$progress%";
}
