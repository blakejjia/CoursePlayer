import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Shared/Providers/load_from_db.dart';
import 'package:course_player/Views/components/my_widgets.dart';
import 'package:course_player/Views/components/playlist_widgets.dart';
import 'package:course_player/main.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool _isGridView = true;

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Courser'),
          leading: const Icon(Icons.play_circle_filled),
          actions: [
            PopupMenuButton(onSelected: (selection) {
              setState(() {
                selection == "GridView"
                    ? _isGridView = true
                    : _isGridView = false;
              }); //TODO:排序here
            }, itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'ListView',
                  child: Text('显示为列表'),
                ),
                PopupMenuItem<String>(
                  value: 'GridView',
                  child: Text('显示为卡片'),
                ),
              ];
            })
          ],
        ),
        body: MRefreshFutureBuilder(
            _refreshData, () => getIt<LoadFromDb>().getAllPlaylists(),
            child: (data) {
          return CourseList(data, isGridView: _isGridView,);
        }));
  }
}

class CourseList extends StatelessWidget {
  final List<Playlist>? playlists;
  final bool isGridView;
  const CourseList(this.playlists, {super.key, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    if (playlists == null || playlists!.isEmpty) {
      return const Center(child: Text("空空如也,请在settings中重构索引"));
    } else {
      return Column(children: [
        Text(
          "Courses",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(
          child:
              isGridView ? _showInCard(playlists!) : _showInList(playlists!),
        ),
      ]);
    }
  }
}

Widget _showInCard(List<Playlist> playlists) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 设置2列
    ),
    itemCount: playlists.length, // Playlist数量
    itemBuilder: (context, index) {
      final playlist = playlists[index];
      return PlaylistCard(playList: playlist);
    },
  );
}

Widget _showInList(List<Playlist> playlists) {
  return ListView.builder(
    itemCount: playlists.length,
    itemBuilder: (context, index) {
      return PlaylistList(playlists[index]);
    },
  );
}
