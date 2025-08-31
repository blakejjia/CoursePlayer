import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lemon/core/data/wash_data.dart';
import 'package:path/path.dart';
import 'package:lemon/core/data/utils/media_library_store.dart';

import '../../features/settings/providers/settings_provider.dart';
import '../../main.dart' show jsonStoreProvider;
// Covers are loaded dynamically; no cover persistence
// album_repository.dart and song_repository.dart are not directly referenced here
// because we access them via Riverpod providers defined in main.dart.

/// This function rebuilds the database from the given path.
/// Given path is the base folder where all the albums are stored.
/// Stream:
/// - currentFolder: current folder index
/// - totalFolder: total number of folders
/// - currentFile: current file index
/// - totalFile: total number of files
Stream<Map<String, int>> rebuildDb(String path, dynamic ref) async* {
  Fluttertoast.showToast(msg: 'Rebuilding database...');
  // init
  ref.read(settingsProvider.notifier).stateRebuilding();
  // Use a single JSON batch to avoid repeated open/write cycles
  final store = ref.read(jsonStoreProvider);
  final batch = await MediaLibraryBatch.start(store);
  // Clear previous library in-memory, commit once at end
  batch.clearSongs();
  batch.clearAlbums();
  // No covers DB to reset; covers will be loaded dynamically during playback

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
      // assign a new album id from batch
      final albumId = batch.nextAlbumId();
      await _handleAlbum(folder, albumId, batch);
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

  // Commit all changes once
  await batch.commit();
  ref.read(settingsProvider.notifier).updateRebuiltTime();
  Fluttertoast.showToast(msg: 'Database rebuilt');
}

/// This function rebuilds the database from the given path.
/// Given path is the base folder of only one album.
/// If the album is already in the database (same sourcePath), it will be updated.
/// If not, add it to database
Future<int> partialRebuild(String baseFolderPath, dynamic ref) async {
  Fluttertoast.showToast(msg: 'Rebuilding database...');
  final directory = Directory(baseFolderPath);
  if (await directory.exists()) {
    final store = ref.read(jsonStoreProvider);
    final batch = await MediaLibraryBatch.start(store);
    // find existing album in batch by path
    final existing = batch.albumByPath(baseFolderPath);
    final int albumId;
    if (existing != null) {
      albumId = existing.id;
      batch.deleteAlbumById(albumId);
      batch.deleteSongsByAlbumId(albumId);
    } else {
      albumId = batch.nextAlbumId();
    }
    await _handleAlbum(directory, albumId, batch);
    await batch.commit();
    Fluttertoast.showToast(msg: 'Database rebuilt');
    ref.read(settingsProvider.notifier).updateRebuiltTime();
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
///
/// album: folder name
/// parts: closest folder name
///
/// path: file path

Future<void> _handleAlbum(
    Directory folder, int albumId, MediaLibraryBatch batch) async {
  try {
    List<File> files = [];
    await for (var entity in folder.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        files.add(entity);
      }
    }
    await _handleSongs(files, folder, albumId, batch);
  } catch (e) {
    // TODO: put it in log file
  }
}

Future<void> _handleSongs(List<File> files, Directory folder, int albumId,
    MediaLibraryBatch batch) async {
  Set<String> authors = {}; // 使用 Set 来避免重复艺术家
  int totalTracks = 0;

  for (File file in files) {
    Tag? tag;
    try {
      tag = await AudioTags.read(file.path);
    } catch (e) {
      continue;
    }

    if (tag != null) {
      // add playlist info
      (tag.albumArtist != null) ? authors.add(tag.albumArtist!) : null;
      // no persistent cover
      // set song "parts"
      List<String> parts = split(relative(file.path, from: folder.path));
      String? part = parts.length > 1 ? parts.first : null;

      // insert song to batch (no immediate disk write)
      batch.insertSong(
        artist: washArtist(tag.albumArtist),
        title: basename(file.path),
        album: albumId,
        length: tag.duration ?? 0,
        path: file.path,
        parts: part,
        playedInSecond: 0,
      );
      totalTracks++;
    }
  }
  // insert album record to batch (no immediate disk write)
  batch.insertAlbum(
    id: albumId,
    title: basename(folder.path),
    author: getAlbumArtistBySet(authors),
    sourcePath: folder.path,
    lastPlayedTime: -1,
    lastPlayedIndex: -1,
    totalTracks: totalTracks,
    playedTracked: 0,
  );
}

// no persistent covers
