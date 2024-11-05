import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/providers/load_from_db.dart';
import 'package:course_player/presentation/screens/conditionalPages/album_songs_view.dart';
import 'package:course_player/logic/blocs/one_playlist/one_playlist_bloc.dart';
import 'package:course_player/presentation/widgets/future_builder.dart';
import 'package:course_player/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playList;
  const PlaylistCard({super.key, required this.playList});

  @override
  Widget build(BuildContext context) {
    return mCard(context, playList);
  }

  // getIt<loadFromDb>().getCoverUint8ListByPlaylist(playlist)
  Widget mCard(BuildContext context, Playlist playlist) {
    return MFutureBuilder(
        () => getIt<LoadFromDb>().getCoverUint8ListByPlaylist(playlist),
        child: (data) {
      return InkWell(
        onTap: () {
          context.read<OnePlaylistBloc>().add(OnePlayListSelected(playlist));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AlbumSongsView(),
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
                child: _courseDetail(context, playlist),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _courseDetail(BuildContext context, Playlist playlist) {
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
          child: Text(playlist.author,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

class PlaylistList extends StatelessWidget {
  final Playlist playlist;
  const PlaylistList(this.playlist, {super.key});

  @override
  Widget build(BuildContext context) {
    return MFutureBuilder(
        () => getIt<LoadFromDb>().getCoverUint8ListByPlaylist(playlist),
        child: (data) {
      return ListTile(
        onTap: () {
          context.read<OnePlaylistBloc>().add(OnePlayListSelected(playlist));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AlbumSongsView(),
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
