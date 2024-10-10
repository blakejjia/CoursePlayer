import 'package:course_player/Shared/components/CourseCard.dart';
import 'package:course_player/Shared/models/playlist.dart';
import 'package:flutter/material.dart';

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
        Padding(        // Recently Played 字样
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Recently played',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(       // Recent
          height: 1000,
          child: GridView.count(
            crossAxisCount: 2, // 每行两列
            children: widget.playlists.map((Playlist playlist) {
              return CourseCard(playList: playlist,);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
