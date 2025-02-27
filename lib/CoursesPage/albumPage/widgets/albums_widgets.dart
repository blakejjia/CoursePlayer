import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/repositories/covers_repository.dart';
import 'package:lemon/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../songListPage/bloc/song_lists_page_bloc.dart';
import '../../songListPage/songs_list_page.dart';
import '../functions.dart';
import 'future_builder.dart';

/// [AlbumCard] is a card that displays a playlist.
///
/// required [Album] as a parameter.
/// It displays the cover image, title, and author of the playlist.
/// When tapped, it navigates to the [SongsListPage] page.
/// It uses the [MFutureBuilder] widget to load the cover image.
class AlbumCard extends StatelessWidget {
  /// [album] is the album to be displayed.
  final Album album;

  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<SongListPageBloc>().add(SongListLocateAlbum(album));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SongsListPage(),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MFutureBuilder(
                () => getIt<CoversRepository>()
                    .getCoverUint8ListByPlaylist(album), child: (data) {
              return SizedBox(
                height: 100,
                width: double.infinity,
                child: Image.memory(data!),
              );
            }),
            Padding(
              // course detail
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: _courseDetail(context, album),
            ),
          ],
        ),
      ),
    );
  }

  Widget _courseDetail(BuildContext context, Album playlist) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              playlist.title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text((playlist.author.isEmpty) ? 'Unknown' : playlist.author,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

/// [AlbumTile] is a list tile that displays a playlist.
class AlbumTile extends StatelessWidget {
  /// [album] is the album to be displayed.
  /// picture information will be derived from database separately
  final Album album;

  const AlbumTile(this.album, {super.key});

  @override
  Widget build(BuildContext context) {
    return MFutureBuilder(
        () => getIt<CoversRepository>().getCoverUint8ListByPlaylist(album),
        child: (data) {
      return ListTile(
        onTap: () {
          context.read<SongListPageBloc>().add(SongListLocateAlbum(album));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SongsListPage(),
            ),
          );
        },
        leading: Image.memory(data!),
        title: Text(album.title),
        subtitle: Text(album.author),
        trailing: Text(formatAlbumProgress(album)),
      );
    });
  }
}
