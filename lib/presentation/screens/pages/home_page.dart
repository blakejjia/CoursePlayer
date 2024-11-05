import 'package:course_player/logic/blocs/audio_info/audio_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioInfoBloc, AudioInfoState>(
        builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.playlist.toString()),
          if (state is AudioInfoSong) // 使用集合 if 语法
            Text(state.index.toString()),
          if (state is AudioInfoSong) // 使用集合 if 语法
            Text(state.indexPlaylist.toString()),
        ],
      );
    });
    //   MRefreshFutureBuilder(
    //   _refreshData,
    //   () => getIt<LoadFromDb>().getAllCovers(),
    //   child: (data) {
    //     return ListView(
    //       children: [
    //         ...data!.map((cover)=> Text('Cover id: ${cover.id}, hash: ${cover.hash}'))
    //       ],
    //     );
    //   },
    // );
  }
}
