part of '../album_page.dart';

class AlbumsView extends StatelessWidget {
  final AlbumPageIdeal state;
  const AlbumsView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return (state.isGridView)
        ? _showInCard(state.albums)
        : _showInList(state.albums);
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

/// [AlbumCard] is a card that displays a playlist.
///
class AlbumCard extends StatelessWidget {
  final Album album;

  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToSongsListPage(context, album),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAlbumCover(context, album,
                height: 100, width: double.infinity),
            Padding(
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            (playlist.author.isEmpty) ? 'Unknown' : playlist.author,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// [AlbumTile] is a list tile that displays a playlist.
class AlbumTile extends StatelessWidget {
  final Album album;

  const AlbumTile(this.album, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: getIt<CoversRepository>().getCoverUint8ListByPlaylist(album),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: CircularProgressIndicator(),
            title: Text('Loading...'),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return ListTile(
            leading: const Icon(Icons.error),
            title: Text(album.title),
            subtitle: Text(album.author),
            trailing: Text(formatAlbumProgress(album)),
          );
        } else {
          return ListTile(
            onTap: () => _navigateToSongsListPage(context, album),
            leading: Image.memory(snapshot.data!),
            title: Text(album.title),
            subtitle: Text(album.author),
            trailing: Text(formatAlbumProgress(album)),
          );
        }
      },
    );
  }
}

Widget _buildAlbumCover(BuildContext context, Album album,
    {required double height, required double width}) {
  return FutureBuilder<Uint8List?>(
    future: getIt<CoversRepository>().getCoverUint8ListByPlaylist(album),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(
          height: height,
          width: width,
          child: const Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError || snapshot.data == null) {
        return SizedBox(
          height: height,
          width: width,
          child: const Center(child: Icon(Icons.error)),
        );
      } else {
        return SizedBox(
          height: height,
          width: width,
          child: Image.memory(snapshot.data!),
        );
      }
    },
  );
}

void _navigateToSongsListPage(BuildContext context, Album album) {
  context.read<SongListPageBloc>().add(SongListLocateAlbum(album));
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
