import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:course_player/Shared/models/models.dart';
import 'package:path/path.dart'; // 用于处理路径

class PlaylistsProvider {
  final List<Playlist> _playlists = [];
  List<Playlist> get playlists => _playlists;

  // 获得 playlists
  Future<void> loadPlaylists() async {
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
                Duration(seconds: tag.duration ?? 0),
                tag.pictures != null ? "" : "", // TODO: add picture
              ));
            }
          }
        }

        if (songs.isNotEmpty) {
          // 储存进 _playlists
          _playlists.add(Playlist(
            title: basename(folder.path),
            songs: songs,
            cover: "cover here",
          )); // TODO: add cover
        }
      }
    } else {
      throw Exception('Directory does not exist');
    }
  }
}
