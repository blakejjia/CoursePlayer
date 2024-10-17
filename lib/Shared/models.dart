import 'package:drift/drift.dart';

class Playlist extends Table {
  final String title;
  final List<Song> songs;
  final String cover; // utf-8 encoded Uint8List

  Playlist({
    required this.title,
    required this.songs,
    required this.cover,
  });
}

class Song {
  final String artist; // 不确定还要不要了
  final String title;
  final int length;
  final String image; // utf-8 encoded Uint8List

  const Song( this.title, this.artist, this.length, this.image);
}

class Artist {
  const Artist({
    required this.name,
  });

  final String name;
}