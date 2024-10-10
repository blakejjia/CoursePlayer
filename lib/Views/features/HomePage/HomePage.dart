import 'package:adaptive_components/adaptive_components.dart';
import 'package:course_player/Shared/models/models.dart';
import 'package:course_player/Views/features/HomePage/Recent.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _examplePlayList = [
    Playlist(
        title: "first course ever",
        songs: [
          Song("1.导论", Artist(name: "liurun"), Duration(seconds: 20), "image")
        ],
        cover: "cover"),
    Playlist(
        title: "second course ever",
        songs: [
          Song("1.导论", Artist(name: "liurun"), Duration(seconds: 20), "image")
        ],
        cover: "cover")
  ]; // TODO:通过 provider 获取

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Recent(playlists: _examplePlayList),
      ]),
    );
  }
}
