import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lemon/backEnd/wash_data.dart';
import 'package:lemon/main.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';

import '../frontEnd/pages/settingsPage/bloc/settings_cubit.dart';
import 'data/repositories/covers_repository.dart';
import 'data/repositories/album_repository.dart';
import 'data/repositories/song_repository.dart';

/// This function rebuilds the database from the given path.
/// Given path is the base folder where all the albums are stored.
/// Stream:
/// - currentFolder: current folder index
/// - totalFolder: total number of folders
/// - currentFile: current file index
/// - totalFile: total number of files
Stream<Map<String, int>> rebuildDb(String path) async* {
  Fluttertoast.showToast(msg: 'Rebuilding database...');
  // init
  getIt<SettingsCubit>().stateRebuilding();
  await getIt<SongRepository>().destroySongDb();
  await getIt<AlbumRepository>().destroyAlbumDb();
  await getIt<CoversRepository>().destroyCoversDb();
  await _loadDefaultCover();

  // locate directory
  final directory = Directory(path);
  if (await directory.exists()) {
    final folders = directory.listSync().whereType<Directory>().toList();
    final totalFolders = folders.length;
    int currentFolder = 0;
    // start loading...
    yield {
      'currentFolder': currentFolder,
      'totalFolder': totalFolders,
      'currentFile': 0,
      'totalFile': 0,
    };

    for (var folder in folders) {
      await _handleAlbum(folder, currentFolder + 10);
      // yeld info
      currentFolder++;
      yield {
        'currentFolder': currentFolder,
        'totalFolder': totalFolders,
        'currentFile': 0,
        'totalFile': 0,
      };
    }
  }

  getIt<SettingsCubit>().updateRebuiltTime();
  Fluttertoast.showToast(msg: 'Database rebuilt');
}

/// This function rebuilds the database from the given path.
/// Given path is the base folder of only one album.
/// If the album is already in the database (same sourcePath), it will be updated.
/// If not, add it to database
Future<int> partialRebuild(String baseFolderPath) async {
  Fluttertoast.showToast(msg: 'Rebuilding database...');
  final directory = Directory(baseFolderPath);
  if (await directory.exists()) {
    int? albumId = await getIt<AlbumRepository>()
        .getAlbumIdByPath(baseFolderPath)
        .then((album) => album?.id);
    if (albumId != null) {
      await getIt<AlbumRepository>().deleteAlbumById(albumId);
      await getIt<SongRepository>().deleteSongsByAlbumId(albumId);
    } else {
      albumId = await getIt<AlbumRepository>().getNextAlbumId();
    }
    await _handleAlbum(directory, albumId);
    Fluttertoast.showToast(msg: 'Database rebuilt');
    getIt<SettingsCubit>().updateRebuiltTime();
    return 0;
  }
  Fluttertoast.showToast(msg: 'Error: Directory not found');
  return 1;
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

Future<void> _handleAlbum(Directory folder, int albumId) async {
  try {
    List<File> files = [];
    await for (var entity in folder.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        files.add(entity);
      }
    }
    await _handleSongs(files, folder, albumId);
  } catch (e) {
    // TODO: put it in log file
  }
}

Future<void> _handleSongs(
    List<File> files, Directory folder, int albumId) async {
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
      (imageId != 0) ? playlistImageId = imageId : null;
      // set song "parts"
      List<String> parts = split(relative(file.path, from: folder.path));
      String? part = parts.length > 1 ? parts.first : null;

      // insert song
      getIt<SongRepository>().insertSong(
          artist: washArtist(tag.albumArtist),
          title: basename(file.path),
          album: albumId,
          length: tag.duration ?? 0,
          imageId: imageId,
          path: file.path,
          parts: part,
          playedInSecond: 0);
      totalTracks++;
    }
  }
  getIt<AlbumRepository>().insertAlbum(
      id: albumId,
      title: basename(folder.path),
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
