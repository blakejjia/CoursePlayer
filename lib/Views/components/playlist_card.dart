import 'dart:typed_data';
import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Shared/Providers/load_from_db.dart';
import 'package:course_player/Views/Pages/conditionalPages/one_playlist.dart';
import 'package:course_player/main.dart';
import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playList;
  const PlaylistCard({super.key, required this.playList});

  @override
  Widget build(BuildContext context) {
    return mCard(context, playList);
  }

  Widget mCard(BuildContext context, Playlist playlist) {
    return FutureBuilder<Uint8List>(
      future:
          getIt<loadFromDb>().getCoverUint8ListByPlaylist(playlist),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 正在等待异步操作完成时显示进度条
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // 如果加载出错显示错误信息
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => one_playlist(playList),
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
                    child: Image.memory(snapshot.data!),
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
        } else {
          // 如果没有任何数据返回
          return const Center(child: Text('No data available'));
        }
      },
    );
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
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        //   child: Text(playlist, // TODO: 显示 playlist.author
        //       overflow: TextOverflow.ellipsis,
        //       style: Theme.of(context).textTheme.bodyMedium,
        //       maxLines: 2,
        //       textAlign: TextAlign.center),
        // ),
      ],
    );
  }
}
