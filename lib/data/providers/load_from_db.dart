import 'dart:typed_data';

import 'package:course_player/data/repositories/covers_repository.dart';
import 'package:course_player/data/repositories/playlist_repository.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/repositories/song_repository.dart';
import 'package:course_player/main.dart';

class LoadFromDb {
  SongRepository songDAO = getIt<SongRepository>();

  Future<List<Song>> getAllSongs() async => songDAO.getAllSongs();

  Future<List<Playlist>> getAllPlaylists() async {
    return getIt<PlaylistRepository>().getAllPlaylists();
  }

  Future<List<Cover>> getAllCovers() async {
    return getIt<CoversRepository>().getAllCovers();
  }

  Future<List<Song>> getSongsByPlaylist(Playlist playlist) async {
    return songDAO.getSongByPlaylist(playlist.title);
  }

  Future<Uint8List> getCoverUint8ListByPlaylist(Playlist playlist) async {
    Cover? cover = await getIt<CoversRepository>().getCoverById(playlist.imageId);
    Cover? defaultCover = await getIt<CoversRepository>().getCoverById(0);
    Uint8List bytes = cover == null? defaultCover!.cover : cover.cover;
    return bytes;
  }
}
