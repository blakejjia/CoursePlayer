import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Shared/Providers/SongProvider.dart';
import 'package:course_player/Views/components/RefreshFutureBuilder.dart';
import 'package:course_player/Views/components/playlist_card.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final SongProvider _songProvider = SongProvider();

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshFutureBuilder(
        _refreshData, () => _songProvider.loadPlaylists(), child: (data) {
      return CourseList(data);
    });
  }
}

class CourseList extends StatelessWidget {
  final List<Playlist>? playlists;
  const CourseList(this.playlists, {super.key});

  @override
  Widget build(BuildContext context) {
    if (playlists == null || playlists!.isEmpty) {
      return Text("空空如也");
    } else {
      return Column(children: [
        Text(
          "Courses",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 设置2列
              // crossAxisSpacing: 10, // 列之间的间距
              // mainAxisSpacing: 10, // 行之间的间距
              // childAspectRatio: 3 / 2, // 每个卡片的宽高比，根据需求调整
            ),
            itemCount: playlists!.length, // Playlist数量
            itemBuilder: (context, index) {
              final playlist = playlists![index];
              return PlaylistCard(playList: playlist);
            },
          ),
        ),
      ]);
    }
  }
}
