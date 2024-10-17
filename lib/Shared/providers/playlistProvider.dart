import 'dart:convert';
import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:course_player/Shared/models.dart';
import 'package:path/path.dart'; // 用于处理路径

class PlaylistsProvider {


  // 获得 playlists
  Future<List<Playlist>> loadPlaylists() async {
    List<Playlist> _playlists = [];
    final directory =
        Directory('/storage/emulated/0/courser'); // TODO: 更多样的文件夹进入方式
    if (await directory.exists()) {
      for (var folder in directory.listSync().whereType<Directory>()) {
        // 遍历 playlist
        List<Song> songs = [];
        for (var file in folder.listSync().whereType<File>()) {
          // 遍历 playlist 中的 song
          if (file.path.endsWith('.mp3')) {
            Tag? tag = await AudioTags.read(file.path);
            if (tag != null) {
              songs.add(Song(
                tag.title ?? "Unknown Title",
                tag.albumArtist ?? "Unknown Artist",
                tag.duration ?? 0,
                tag.pictures.isNotEmpty ? utf8.decode(tag.pictures[0].bytes) : "", // TODO: add picture
              ));
            }
          }
        }

        if (songs.isNotEmpty) {
          // 储存进 _playlists
          _playlists.add(Playlist(
            title: basename(folder.path),
            songs: songs,
            cover: songs[0].image, // TODO: change cover
          ));
        }
      }
    } else {
      throw Exception('Directory does not exist');
    }
    return _playlists;
  }
}
