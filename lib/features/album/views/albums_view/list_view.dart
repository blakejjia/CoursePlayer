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
    return ListTile(
      onTap: () => _navigateToSongsListPage(context, album),
      leading: Image.asset("assets/default_cover.jpeg"),
      title: Text(album.title),
      subtitle: Text(album.author),
      trailing: Text(formatAlbumProgress(album)),
    );
  }
}
