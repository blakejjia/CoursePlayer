import 'package:course_player/Shared/models/models.dart';
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
        Text(widget.playlists.toString()), //TODO:删掉
        Recent(playlists: widget.playlists),
      ]),
    );
  }
}
