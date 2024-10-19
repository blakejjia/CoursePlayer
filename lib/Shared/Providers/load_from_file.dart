import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:course_player/Shared/DAO/DAO.dart';
import 'package:course_player/main.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';

class loadFromFile{

  Future<int> _formatImage(List<Picture>? pictures) async {
    // 格式化tag.pictures,转换成imageId，并在coverDAO中加上缺失的图片，默认返回0
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
    // 格式化playlist中song的作者，如果大于3就是群星
    if (authors.length < 3) {
      return authors.join(' ');
    } else {
      return "群星";
    }
  }

  Future<int> _loadDefaultCover() async{
    final coverData = await rootBundle.load('assets/default_cover.jpeg').then((data) => data.buffer.asUint8List());
    return getIt<CoversDao>().createCoverWithId(0, coverData, sha256.convert(coverData).toString());
  }

  Future<void> load() async {
    getIt<SongDAO>().destroySongDb();
    getIt<PlaylistsDao>().destroyPlaylistDb();
    getIt<CoversDao>().destroyCoversDb();
    _loadDefaultCover();
    final directory =
    Directory('/storage/emulated/0/courser'); // TODO: 更多样的文件夹进入方式

    // -------------setup 👆 --------------------------------
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

              getIt<SongDAO>().insertSong(
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
}