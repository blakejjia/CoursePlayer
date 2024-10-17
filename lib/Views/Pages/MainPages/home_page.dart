import 'package:course_player/Shared/providers/playlistProvider.dart';
import 'package:course_player/Shared/models.dart';
import 'package:course_player/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Playlist>>(
      future: getIt<PlaylistsProvider>().loadPlaylists(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 正在等待异步操作完成
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 异步操作出错
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // 异步操作成功完成
          return Text('Data: ${snapshot.data}');
        } else {
          // 未执行到任何 Future 结果
          return Text('No data');
        }
      },
    );
  }
}

