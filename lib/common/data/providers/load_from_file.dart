import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:lemon/common/utils/wash_data.dart';
import 'package:lemon/main.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';

import '../../../settingsPage/bloc/settings_cubit.dart';
import '../repositories/covers_repository.dart';
import '../repositories/playlist_repository.dart';
import '../repositories/song_repository.dart';

Future<int> _formatImage(List<Picture>? pictures) async {
  // 格式化tag.pictures,转换成imageId，并在coverDAO中加上缺失的图片，默认返回0
  if (pictures == null || pictures.isEmpty) {
    return 0;
  }

  Uint8List pictureBytes = pictures[0].bytes;
  String hash = sha256.convert(pictureBytes).toString();
  CoversRepository coversDao = getIt<CoversRepository>();
  int? coverId = await coversDao.getCoverIdByHash(hash);
  return coverId ?? coversDao.createCover(pictureBytes, hash);
}



Future<int> _loadDefaultCover() async {
  final coverData = await rootBundle
      .load("assets/default_cover.jpeg")
      .then((data) => data.buffer.asUint8List());
  return getIt<CoversRepository>()
      .createCoverWithId(0, coverData, sha256.convert(coverData).toString());
}

Future<void> load(String path) async {
  getIt<SettingsCubit>().stateRebuilding();
  await getIt<SongRepository>().destroySongDb();
  await getIt<PlaylistRepository>().destroyPlaylistDb();
  await getIt<CoversRepository>().destroyCoversDb();
  await _loadDefaultCover();
  final directory = Directory(path);

  if (await directory.exists()) {
    for (var folder in directory.listSync().whereType<Directory>()) {
      // 便利文件夹（Playlist）
      await _processOnePlaylist(folder);
    }
  }
  getIt<SettingsCubit>().updateRebuiltTime();
}

// Handling one playlist, 默认一个顶层folder对应一个playlist
Future<void> _processOnePlaylist(Directory folder) async {
  List<File> files = await (Directory directory) async {
    List<File> files = [];
    await for (var entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        files.add(entity);
      }
    }
    return files;
  }(folder);
  await _processFiles(files, folder);
}

Future<void> _processFiles(List<File> files, Directory folder) async {
  Set<String> authors = {}; // 使用 Set 来避免重复艺术家
  int imageId = 0; // 如果没有可用图片，那就是 0
  for (File file in files) {
    // in case of non-mp3 files
    // TODO: create log file for failures - see reason.
    try {
      await AudioTags.read(file.path);
    } catch (e) {
      continue;
    }
    Tag? tag = await AudioTags.read(file.path);
    if (tag != null) {
      // 添加艺术家到列表
      (tag.albumArtist != null) ? authors.add(tag.albumArtist!) : null;
      (imageId == 0 && tag.pictures.isNotEmpty)
          ? imageId = await _formatImage(tag.pictures)
          : null;

      // 设置封面图片 ID，只设置一次
      getIt<SongRepository>().insertSong(
        artist: washArtist(tag.albumArtist),
        title: basename(file.path),
        playlist: basename(folder.path),
        length: tag.duration ?? 0,
        imageId: await _formatImage(tag.pictures),
        path: file.path,
      );
    }
  }
  getIt<PlaylistRepository>()
      .insertPlaylist(basename(folder.path), washPlaylistArtist(authors), imageId);
}
