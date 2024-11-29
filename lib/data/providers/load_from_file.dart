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
  // 格式化tag.pictures, 转换成imageId，并在coverDAO中加上缺失的图片，默认返回0
  if (pictures == null || pictures.isEmpty) {
    return 0; // 如果没有封面图，返回默认值 0
  }

  Uint8List pictureBytes = pictures[0].bytes;  // 获取封面图的字节数据
  String hash = sha256.convert(pictureBytes).toString();  // 计算哈希值
  CoversRepository coversDao = getIt<CoversRepository>();

  // 查找数据库中是否已存在此封面
  int? coverId = await coversDao.getCoverIdByHash(hash);
  if (coverId == null) {
    // 如果没有找到封面，创建并存储封面
    await coversDao.createCover(pictureBytes, hash); // No need to return the ID anymore
    coverId = await coversDao.getCoverIdByHash(hash);  // Re-fetch the ID after creation
  }
  return coverId ?? 0;
}

String _formatAuthor(Set<String> authors) {
  // 格式化 playlist 中 song 的作者，如果作者数量大于3，返回 '群星'
  if (authors.length < 3) {
    return authors.join(' ');
  } else {
    return "群星";
  }
}

Future<int> _loadDefaultCover() async {
  final coverData = await rootBundle.load("assets/default_cover.jpeg").then((data) => data.buffer.asUint8List());
  await getIt<CoversRepository>().createCoverWithId(0, coverData, sha256.convert(coverData).toString());
  return 0;
}

Future<void> load(String path) async {
  getIt<SettingsCubit>().stateRebuilding();
  await getIt<SongRepository>().destroySongDb();
  await getIt<PlaylistRepository>().destroyPlaylistDb();
  await getIt<CoversRepository>().destroyCoversDb();
  await _loadDefaultCover();  // 加载默认封面
  final directory = Directory(path);

  if (await directory.exists()) {
    for (var folder in directory.listSync().whereType<Directory>()) {
      // 处理每一个播放列表文件夹
      await _processOnePlaylist(folder);
    }
  }
  getIt<SettingsCubit>().updateRebuiltTime();
}

// 处理一个播放列表
Future<void> _processOnePlaylist(Directory folder) async {
  List<File> files = await (Directory directory) async {
    List<File> files = [];
    await for (var entity in directory.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        files.add(entity);
      }
    }
    return files;
  }(folder);

  await _processFiles(files, folder);
}

// 处理播放列表中的所有文件
Future<void> _processFiles(List<File> files, Directory folder) async {
  Set<String> authors = {};  // 使用 Set 来避免重复艺术家
  int imageId = 0;  // 如果没有封面图像，使用默认值 0
  for (File file in files) {
    // 遍历播放列表中的每个音频文件
    if (file.path.endsWith('.mp3')) {
      Tag? tag = await AudioTags.read(file.path);  // 读取音频文件标签
      if (tag != null) {
        // 添加艺术家到列表
        (tag.albumArtist != null) ? authors.add(tag.albumArtist!) : null;

        // 获取封面图像 ID，只设置一次
        if (imageId == 0 && tag.pictures.isNotEmpty) {
          imageId = await _formatImage(tag.pictures);
        }

        // 插入歌曲信息
        await getIt<SongRepository>().insertSong(
          artist: tag.albumArtist ?? "Unknown Artist",
          title: basename(file.path),
          playlistId: basename(folder.path),
          length: tag.duration ?? 0,
          imageId: imageId,  // 使用封面 ID
          path: file.path,
        );
      }
    }
  }

  // 创建播放列表
  await getIt<PlaylistRepository>().createPlaylist(
    basename(folder.path),
    _formatAuthor(authors),
    imageId,
  );
}
