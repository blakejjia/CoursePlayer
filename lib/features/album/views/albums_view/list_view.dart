part of 'albums_view.dart';

Widget _showInList(List<Album> albums) {
  return ListView.builder(
    itemCount: albums.length,
    itemBuilder: (context, index) {
      return AlbumListView(albums[index]);
    },
  );
}

/// [AlbumListView] is a list tile that displays a playlist.
class AlbumListView extends StatelessWidget {
  final Album album;

  const AlbumListView(this.album, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: providerContainer
          .read(coversRepositoryProvider)
          .getCoverUint8ListByPlaylist(album),
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
