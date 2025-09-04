import 'dart:async';
import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:path/path.dart';

import 'package:lemon/core/data/storage.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../main.dart' show jsonStoreProvider;

Future<void> loadDb(
  String path,
  Ref ref,
  void Function(Map<String, int>) onProgress,
) async {
  // init variables
  ref.read(settingsProvider.notifier).stateRebuilding();
  final store = ref.read(jsonStoreProvider);
  final batch = await MediaLibraryBatch.start(store);
  final root = Directory(path);
  if (!await root.exists()) throw Exception('Directory does not exist: $path');

  // Collect albumns
  // - Delete albums present in storage but missing on disk
  // - Only load folders that are new (on disk but not present in batch)
  final coursePaths = <String>{};
  await for (final e in root.list(recursive: false, followLinks: false)) {
    if ((e is Directory)) coursePaths.add(e.path);
  }
  final currentAlbumns = batch.albums.map((e) => e.sourcePath).toSet();
  final removed = currentAlbumns.difference(coursePaths);
  final toAdd = coursePaths.difference(currentAlbumns);
  onProgress({'totalFolder': toAdd.length});

  // remove albums that are no longer present
  for (final path in removed) {
    final album = batch.albumByPath(path);
    if (album != null) {
      batch.deleteAlbumById(album.id);
      debugPrint('Deleted album not found on disk: ${path}');
    }
  }

  // load new albums
  var idx = 0;
  for (final folder in toAdd) {
    try {
      await loadFolder(
        folder,
        ref,
        batch: batch,
        onProgress: onProgress,
      );
      idx++;
      onProgress({'currentFolder': idx});
    } catch (e) {
      idx++;
      debugPrint('Error processing folder $folder: $e');
      onProgress({'currentFolder': idx});
    }
  }

  // commit
  await batch.commit();
  Fluttertoast.showToast(msg: 'Course updated successfully');
  ref.read(settingsProvider.notifier).updateRebuiltTime();
}

/// =============================================================
/// Incremental load for a single course folder.
///
/// If [batch] is provided the function will use it and will not commit the
/// batch unless [commit] is true. When [batch] is omitted the function will
/// create its own batch and commit it at the end (unless commit=false).
Future<int> loadFolder(
  String baseFolderPath,
  dynamic ref, {
  required MediaLibraryBatch batch,
  void Function(Map<String, int>)? onProgress,
}) async {
  // init collection
  final courseFolder = Directory(baseFolderPath);
  final audioFiles = await _collectAudioFiles(courseFolder);
  if (audioFiles.isEmpty) throw Exception('No audio files found');

  // ================= Create songs and insert album ==========================
  final songs = <Song>[];
  final authors = <String>{};
  final total = audioFiles.length;
  var processed = 0;

  // sorting and load songs
  audioFiles.sort((a, b) => basename(a.path).compareTo(basename(b.path)));
  for (final file in audioFiles) {
    try {
      // read tags
      final tag = await AudioTags.read(file.path);
      final artist = _washArtist(tag?.albumArtist ?? '');
      authors.add(artist);

      final song = Song(
        id: batch.nextSongId(),
        artist: artist,
        title: _cleanFileName(basename(file.path)),
        length: tag?.duration ?? 0,
        path: file.path,
        addedAt: DateTime.now(),
      );

      songs.add(song);
    } catch (e) {
      debugPrint('Error processing audio file ${file.path}: $e');
    } finally {
      processed++;
      onProgress?.call({
        'currentFile': processed,
        'totalFile': total,
      });
    }
  }

  // create albumn
  batch.insertAlbumWithSongs(
    title: basename(courseFolder.path),
    author: _determineAlbumArtist(authors),
    sourcePath: courseFolder.path,
    songs: songs,
  );

  return 0;
}

// ============================ utils ========================

// Collect audio files directly under [dir] (non-recursive). Nested
// subfolders are ignored so they won't contribute songs to this album.
Future<List<File>> _collectAudioFiles(Directory dir) async {
  final files = <File>[];
  try {
    await for (final e in dir.list(recursive: true, followLinks: false)) {
      if (e is File && _isAudioFile(e.path)) files.add(e);
    }
  } catch (e) {
    debugPrint('Error listing directory ${dir.path}: $e');
  }
  files.sort((a, b) => basename(a.path).compareTo(basename(b.path)));
  return files;
}

bool _isAudioFile(String filePath) {
  final fileExtension = extension(filePath).toLowerCase();
  const audioExtensions = {
    '.mp3',
    '.m4a',
    '.aac',
    '.flac',
    '.wav',
    '.ogg',
    '.opus',
    '.wma'
  };
  return audioExtensions.contains(fileExtension);
}

String _determineAlbumArtist(Set<String> authors) {
  if (authors.isEmpty) return 'Unknown Artist';
  if (authors.length == 1) return authors.first;
  return authors.join(', ');
}

String _cleanFileName(String filename) {
  var cleaned = basenameWithoutExtension(filename);
  cleaned = cleaned.replaceFirst(RegExp(r'^\d+[\.\-\s]*'), '');
  cleaned = cleaned.replaceFirst(
      RegExp(r'^Track\s*\d+[\.\-\s]*', caseSensitive: false), '');
  return cleaned.trim().isNotEmpty ? cleaned.trim() : filename;
}

String _washArtist(String? artist) {
  if (artist == null || artist.length > 30) {
    return "";
  }
  return artist;
}
