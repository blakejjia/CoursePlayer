import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Shared/providers/SongProvider.dart';
import 'package:course_player/main.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<List<Song>>(
        future: getIt<SongProvider>().loadSongFromDb(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 正在等待异步操作完成
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // 异步操作出错
            return ListView(
              children: [
                Text('Error: ${snapshot.error}'),
              ],
            );
          } else if (snapshot.hasData) {
            // 异步操作成功完成
            return ListView(
              children: [
                Text('Data: '+snapshot.data.toString()),
              ],
            );
          } else {
            // 未执行到任何 Future 结果
            return Text('No data');
          }
        },
      ),
    );
  }
}

