import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Shared/DAO/DAO.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart';

class SongProvider {
  SongDAO songDAO = SongDAO();

  // 获得 playlists
  Future<void> loadSongFromDictionary() async {
    songDAO.destroySongDb();
    final directory = Directory('/storage/emulated/0/courser'); // TODO: 更多样的文件夹进入方式
    if (await directory.exists()) {
      for (var folder in directory.listSync().whereType<Directory>()) {
        for (var file in folder.listSync().whereType<File>()) {
          // 遍历 playlist 中的 song
          if (file.path.endsWith('.mp3')) {
            Tag? tag = await AudioTags.read(file.path);
            if (tag != null) {
              songDAO.insertSong(SongsCompanion(
                title: Value(basename(file.path)),
                artist: Value(tag.albumArtist ?? "Unknown Artist"),
                length: Value(tag.duration ?? 0),
                playlist: Value(basename(folder.path)),
                path: Value(file.path),
                imageId: Value(1), // TODO: add picture tag.pictures.isNotEmpty ? base64Encode(tag.pictures[0].bytes) : ""
              ));
            }
          }
        }
      }
    }
  }

  Future<List<Song>> loadSongFromDb() async =>  songDAO.getAllSongs();

  Future<List<Playlist>> loadPlaylists() async{       // TODO: provide by playlist table
    List<String?> titles = await songDAO.getPlaylists();
    return titles
          .where((title) => title != null) // 过滤掉 null 值
          .map((title) => Playlist(title: title!, author: "aaa", imageId: 0)) // 创建 Playlist 实例
          .toList(); // 转换为 List<Playlist>
  }

  Future<List<Song>> loadSongByPlaylist(Playlist playlist) async{
    return songDAO.getSongByPlaylist(playlist.title);
  }

}
