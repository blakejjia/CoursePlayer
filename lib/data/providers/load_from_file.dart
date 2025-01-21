import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:course_player/data/repositories/covers_repository.dart';
import 'package:course_player/data/repositories/playlist_repository.dart';
import 'package:course_player/data/repositories/song_repository.dart';
import 'package:course_player/logic/blocs/settings/settings_cubit.dart';
import 'package:course_player/main.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';

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

String _formatAuthor(Set<String> authors) {
  // 格式化playlist中song的作者，如果大于3就是群星
  if (authors.length < 3) {
    return authors.join(' ');
  } else {
    return "群星";
  }
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
    // 遍历 playlist 中的 song
    if (file.path.endsWith('.mp3')) {
      try {
        Tag? tag = await AudioTags.read(file.path);
        if (tag != null) {
          // 添加艺术家到列表
          (tag.albumArtist != null) ? authors.add(tag.albumArtist!) : null;
          (imageId == 0 && tag.pictures.isNotEmpty)
              ? imageId = await _formatImage(tag.pictures)
              : null;
          getIt<SongRepository>().insertSong(
            artist: tag.albumArtist ?? "Unknown Artist",
            title: basename(file.path),
            playlist: basename(folder.path),
            length: tag.duration ?? 0,
            imageId: await _formatImage(tag.pictures),
            path: file.path,
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }
  getIt<PlaylistRepository>()
      .createPlaylist(basename(folder.path), _formatAuthor(authors), imageId);
}
