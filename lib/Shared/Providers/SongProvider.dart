import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Shared/DAO/DAO.dart';
import 'package:course_player/main.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';

class SongProvider {
  SongDAO songDAO = getIt<SongDAO>();

  Future<int> _formatImage(List<Picture>? pictures) async {
    if (pictures == null || pictures.isEmpty) {
      return 0;
    }

    Uint8List pictureBytes = pictures[0].bytes;
    String hash = sha256.convert(pictureBytes).toString();
    CoversDao coversDao = getIt<CoversDao>();
    int? coverId = await coversDao.getCoverIdByHash(hash);
    return coverId ?? coversDao.createCover(pictureBytes, hash);
  }

  String _formatAuthor(Set<String> authors) {
    if (authors.length < 3) {
      // 将作者列表转为字符串，用空格隔开
      return authors.join(' ');
    } else {
      // 如果作者数量大于等于 3，则返回 "群星"
      return "群星";
    }
  }


  // 获得 playlists
  Future<void> loadSongFromDictionary() async {
    songDAO.destroySongDb();
    getIt<PlaylistsDao>().destroyPlaylistDb();
    final directory =
        Directory('/storage/emulated/0/courser'); // TODO: 更多样的文件夹进入方式

    if (await directory.exists()) {
      for (var folder in directory.listSync().whereType<Directory>()) {
        // 便利文件夹（Playlist）
        Set<String> _authors = {}; // 使用 Set 来避免重复艺术家
        int _imageId = 0; // 如果没有可用图片，那就是 0
        for (var file in folder.listSync().whereType<File>()) {
          // 遍历 playlist 中的 song
          if (file.path.endsWith('.mp3')) {
            Tag? tag = await AudioTags.read(file.path);
            if (tag != null) {
              // 添加艺术家到列表
              if (tag.albumArtist != null) {
                _authors.add(tag.albumArtist!);
              }

              // 设置封面图片 ID，只设置一次
              if (_imageId == 0 && tag.pictures.isNotEmpty) {
                _imageId = await _formatImage(tag.pictures);
              }

              songDAO.insertSong(
                artist: tag.albumArtist ?? "Unknown Artist",
                title: basename(file.path),
                playlist: basename(folder.path),
                length: tag.duration ?? 0,
                imageId: await _formatImage(tag.pictures),
                path: file.path,
              );
            }
          }
        }
        getIt<PlaylistsDao>().createPlaylist(
            basename(folder.path), _formatAuthor(_authors), _imageId);
      }
    }
  }

  Future<List<Song>> loadSongFromDb() async => songDAO.getAllSongs();

  Future<List<Playlist>> loadPlaylists() async {
    return getIt<PlaylistsDao>().getAllPlaylists();
  }

  Future<List<Song>> loadSongByPlaylist(Playlist playlist) async {
    return songDAO.getSongByPlaylist(playlist.title);
  }
}
