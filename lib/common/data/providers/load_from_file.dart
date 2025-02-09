import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:lemon/common/utils/wash_data.dart';
import 'package:lemon/main.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';

import '../../../settingsPage/bloc/settings_cubit.dart';
import '../repositories/covers_repository.dart';
import '../repositories/album_repository.dart';
import '../repositories/song_repository.dart';


Future<void> load(String path) async {
  // init
  getIt<SettingsCubit>().stateRebuilding();
  await getIt<SongRepository>().destroySongDb();
  await getIt<AlbumRepository>().destroyAlbumDb();
  await getIt<CoversRepository>().destroyCoversDb();
  await _loadDefaultCover();

  // locate directory
  final directory = Directory(path);
  if (await directory.exists()) {
    for (var folder in directory.listSync().whereType<Directory>()) {
      await _handleAlbum(folder);
    }
  }
  getIt<SettingsCubit>().updateRebuiltTime();
}

/// Handling one playlist, write to both [Song] and [Playlist] table
///
/// For [Playlist] table:
/// title: folder name
/// artist: see [washArtist]
/// imageId: see [_handlePictureSerialize]
/// sourcePath: folder path
///
/// lastPlayed: -1 TODO: if lastPlayed = -1, show as not played
/// totalTracks: count of songs
/// playedTracks: 0
///
/// For [Song] table:
///
/// artist: see [washArtist]
/// title: file name
/// length: duration of the song
/// imageId: see [_handlePictureSerialize]
///
/// album: folder name
/// parts: closest folder name
///
/// path: file path

Future<void> _handleAlbum(Directory folder) async {
  try {
    List<File> files = [];
    await for (var entity in folder.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        files.add(entity);
      }
    }
    await _handleSongs(files, folder);
  } catch (e) {
    // TODO: put it in log file
    print('Error while accessing folder: $e');
  }
}

Future<void> _handleSongs(List<File> files, Directory folder) async {
  Set<String> authors = {}; // 使用 Set 来避免重复艺术家
  int playlistImageId = 0; // 如果没有可用图片，那就是 0
  int totalTracks = 0;

  for (File file in files) {
    // in case of non-mp3 files
    // TODO: create log file for failures - see reason.
    Tag? tag;
    try {
      tag = await AudioTags.read(file.path);
    } catch (e) {
      continue;
    }

    if (tag != null) {
      // add playlist info
      (tag.albumArtist != null) ? authors.add(tag.albumArtist!) : null;
      // set cover ID
      int imageId = await _handlePictureSerialize(tag.pictures);
      (imageId!=0) ? playlistImageId = imageId : null;

      getIt<SongRepository>().insertSong(
        artist: washArtist(tag.albumArtist),
        title: basename(file.path),
        album: basename(folder.path),
        length: tag.duration ?? 0,
        imageId: imageId,
        path: file.path,
        parts: basename(folder.parent.path),
        playedInSecond: 0
      );
      totalTracks++;
    }
  }
  getIt<AlbumRepository>().insertAlbum(title: basename(folder.path),
      author: getAlbumArtistBySet(authors),
      imageId: playlistImageId,
      sourcePath: folder.path,
      lastPlayedTime: -1,
      lastPlayedIndex: -1,
      totalTracks: totalTracks,
      playedTracked: 0);
}


Future<int> _handlePictureSerialize(List<Picture>? pictures) async {
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