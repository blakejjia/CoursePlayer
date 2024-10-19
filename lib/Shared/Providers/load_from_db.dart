import 'dart:typed_data';

import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Shared/DAO/dao.dart';
import 'package:course_player/main.dart';

class LoadFromDb {
  SongDAO songDAO = getIt<SongDAO>();

  Future<List<Song>> getAllSongs() async => songDAO.getAllSongs();

  Future<List<Playlist>> getAllPlaylists() async {
    return getIt<PlaylistsDao>().getAllPlaylists();
  }

  Future<List<Cover>> getAllCovers() async {
    return getIt<CoversDao>().getAllCovers();
  }

  Future<List<Song>> getSongsByPlaylist(Playlist playlist) async {
    return songDAO.getSongByPlaylist(playlist.title);
  }

  Future<Uint8List> getCoverUint8ListByPlaylist(Playlist playlist) async {
    Cover? cover = await getIt<CoversDao>().getCoverById(playlist.imageId);
    Cover? defaultCover = await getIt<CoversDao>().getCoverById(0);
    Uint8List bytes = cover == null? defaultCover!.cover : cover.cover;
    return bytes;
  }
}
