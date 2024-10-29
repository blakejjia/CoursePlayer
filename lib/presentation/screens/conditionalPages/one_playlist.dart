import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/providers/load_from_db.dart';
import 'package:course_player/presentation/widgets/my_widgets.dart';
import 'package:course_player/main.dart';
import 'package:flutter/material.dart';

class OnePlaylist extends StatefulWidget {
  final Playlist playlist;
  const OnePlaylist(this.playlist, {super.key});

  @override
  State<OnePlaylist> createState() => _OnePlaylistState();
}

class _OnePlaylistState extends State<OnePlaylist> {
  late Playlist _playlist;
  final LoadFromDb songProvider = LoadFromDb();

  // ---------- function sort ------------------
  List<Song> sortByTitle(List<Song> songs) {
    songs.sort((a, b) => a.title.compareTo(b.title));
    return songs;
  }

  @override
  void initState() {
    super.initState();
    _playlist = widget.playlist;
  }

  Future<void> _refreshFunction() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), //TODO: add some functions to app bar
      body: MRefreshFutureBuilder(
          _refreshFunction, () => songProvider.getSongsByPlaylist(_playlist),
          child: (data) => _SongList(data, widget.playlist)),
    );
  }
}

class _SongList extends StatelessWidget {
  final List<Song>? songs;
  final Playlist playlist;
  const _SongList(this.songs, this.playlist);

  @override
  Widget build(BuildContext context) {
    if (songs == null || songs!.isEmpty) {
      return const Center(
        child: Text("空空如也"),
      );
    } else {
      return Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: songs!.length + 1, // Playlist数量
            itemBuilder: (context, index) {
              if (index == 0) {
                return _heading(context, playlist);
              } else {
                return _SongTile(song: songs![index - 1]);
              }
            },
          ),
        ),
      ]);
    }
  }
}

class _SongTile extends StatelessWidget {
  final Song song;
  const _SongTile({required this.song});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_formatTitle(song.title)),
      subtitle: Row(
        children: [
          Text(song.artist),
          const SizedBox(
            width: 20,
          ),
          Text(_formatDuration(song.length))
        ],
      ),
      trailing: const Icon(Icons.more_vert),
    );
  }
}

String _formatDuration(int duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  // 计算小时、分钟和秒
  int hours = duration ~/ 3600;
  int minutes = (duration % 3600) ~/ 60;
  int seconds = duration % 60;
  String twoDigitMinutes = twoDigits(minutes);
  String twoDigitSeconds = twoDigits(seconds);

  if (hours > 0) {
    return "${twoDigits(hours)}:$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

String _formatTitle(String title) {
  int lastDotIndex = title.lastIndexOf('.');
  // 如果存在 '.', 则去掉末尾的后缀
  if (lastDotIndex != -1) {
    return title.substring(0, lastDotIndex);
  }
  return title;
}

Widget _heading(BuildContext context, Playlist playlist) {
  return MFutureBuilder(
      () => getIt<LoadFromDb>().getCoverUint8ListByPlaylist(playlist),
      child: (data) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 2,
          child: Image.memory(data!),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
          child: Text(
            playlist.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Text(
            playlist.author,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  });
}
