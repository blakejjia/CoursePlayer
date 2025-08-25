part of 'albums_view.dart';

Widget _showInCard(List<Album> albums) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 设置2列
    ),
    itemCount: albums.length, // Playlist数量
    itemBuilder: (context, index) {
      final playlist = albums[index];
      return AlbumCardView(album: playlist);
    },
  );
}

/// [AlbumCardView] is a card that displays a playlist.
///
class AlbumCardView extends StatelessWidget {
  final Album album;

  const AlbumCardView({super.key, required this.album});

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
