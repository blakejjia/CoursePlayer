import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Shared/DAO/DAO.dart';
import 'package:course_player/main.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart';

class SongProvider {

  // 获得 playlists
  Future<void> loadSongFromDictionary() async {
    getIt<SongDAO>().destroySongDb();
    final directory = Directory('/storage/emulated/0/courser'); // TODO: 更多样的文件夹进入方式
    if (await directory.exists()) {
      for (var folder in directory.listSync().whereType<Directory>()) {
        for (var file in folder.listSync().whereType<File>()) {
          // 遍历 playlist 中的 song
          if (file.path.endsWith('.mp3')) {
            Tag? tag = await AudioTags.read(file.path);
            if (tag != null) {
              getIt<SongDAO>().insertSong(SongsCompanion(
                title: Value(tag.title ?? "Unknown Title"),
                artist: Value(tag.albumArtist ?? "Unknown Artist"),
                length: Value(tag.duration ?? 0),
                playlist: Value(basename(folder.path)),
                path: Value(file.path),
                image: Value(1), // TODO: add picture tag.pictures.isNotEmpty ? base64Encode(tag.pictures[0].bytes) : ""
              ));
            }
          }
        }
      }
    }
  }

  Future<List<Song>> loadSongFromDb() async{
    return getIt<SongDAO>().getAllSongs();
  }

}
