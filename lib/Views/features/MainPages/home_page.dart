import 'package:course_player/Shared/models/models.dart';
import 'package:course_player/Shared/shared.dart';
import 'package:course_player/Views/features/HomePage/recent.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  List<Playlist> playlists = [];
  HomePage({super.key, required this.playlists});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Recent(playlists: widget.playlists),
      ]),
    );
  }
}

class Recent extends StatefulWidget {
  final List<Playlist> playlists;
  const Recent({super.key, required this.playlists});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          // Recently Played 字样
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Recently played',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          // Recent
          height: 1000,
          child: GridView.count(
            crossAxisCount: 2, // 每行两列
            children: widget.playlists.map((Playlist playlist) {
              return CourseCard(
                playList: playlist,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
