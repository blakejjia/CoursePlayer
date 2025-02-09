import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/providers/load_from_db.dart';
import 'package:lemon/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../CoursesPage/songListPage/bloc/song_lists_page_bloc.dart';
import '../../CoursesPage/songListPage/songs_list_page.dart';
import '../../audioPage/presentation/future_builder.dart';

/// [PlaylistCard] is a card that displays a playlist.
///
/// required [Album] as a parameter.
/// It displays the cover image, title, and author of the playlist.
/// When tapped, it navigates to the [SongsListPage] page.
/// It uses the [MFutureBuilder] widget to load the cover image.
class PlaylistCard extends StatelessWidget {
  final Album playList;
  const PlaylistCard({super.key, required this.playList});

  @override
  Widget build(BuildContext context) {
    return MFutureBuilder(
        () => getIt<LoadFromDb>().getCoverUint8ListByPlaylist(playList),
        child: (data) {
      return InkWell(
        onTap: () {
          context.read<SongListPageBloc>().add(AudioInfoLocatePlaylist(playList));
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
              SizedBox(
                height: 100,
                width: double.infinity,
                child: Image.memory(data!),
              ),
              Padding(
                // course detail
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: _courseDetail(context, playList),
              ),
            ],
          ),
        ),
      );
    });
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

class PlaylistList extends StatelessWidget {
  final Album playlist;
  const PlaylistList(this.playlist, {super.key});

  @override
  Widget build(BuildContext context) {
    return MFutureBuilder(
        () => getIt<LoadFromDb>().getCoverUint8ListByPlaylist(playlist),
        child: (data) {
      return ListTile(
        onTap: () {
          context.read<SongListPageBloc>().add(AudioInfoLocatePlaylist(playlist));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SongsListPage(),
            ),
          );
        },
        leading: Image.memory(data!),
        title: Text(playlist.title),
        subtitle: Text(playlist.author),
      );
    });
  }
}
