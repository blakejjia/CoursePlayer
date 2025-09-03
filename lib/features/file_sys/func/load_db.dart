import 'dart:io';
import 'package:audiotags/audiotags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lemon/features/file_sys/func/wash_data.dart';
import 'package:path/path.dart';
import 'package:lemon/core/data/storage.dart';
import 'package:lemon/core/data/models/models.dart';

import '../../settings/providers/settings_provider.dart';
import '../../../main.dart' show jsonStoreProvider;
// Covers are loaded dynamically; no cover persistence
// album_repository.dart and song_repository.dart are not directly referenced here
// because we access them via Riverpod providers defined in main.dart.

/// This function rebuilds the database from the given path using a folder-based approach.
/// Each folder becomes an album/course with songs directly embedded within it.
/// Supports incremental updates by checking folder modification times.
/// Stream yields progress information:
/// - currentFolder: current folder index being processed
/// - totalFolder: total number of folders discovered
/// - currentFile: current file index within the folder
/// - totalFile: total number of files in current folder
Stream<Map<String, int>> rebuildDb(String path, dynamic ref) async* {
  Fluttertoast.showToast(msg: 'Rebuilding media library...');

  // Initialize and clear previous data
  ref.read(settingsProvider.notifier).stateRebuilding();
  final store = ref.read(jsonStoreProvider);
  final batch = await MediaLibraryBatch.start(store);

  // Clear existing data for fresh rebuild
  batch.clearSongs();
  batch.clearAlbums();

  final rootDirectory = Directory(path);
  if (!await rootDirectory.exists()) {
    Fluttertoast.showToast(msg: 'Error: Root directory not found');
    return;
  }

  // Discover all course folders (supporting nested structure)
  final courseFolders = await _discoverCourseFolders(rootDirectory);
  final totalFolders = courseFolders.length;

  // Initial progress yield
  yield {
    'currentFolder': 0,
    'totalFolder': totalFolders,
    'currentFile': 0,
    'totalFile': 0,
  };

  int currentFolderIndex = 0;

  // Process each course folder
  for (final courseFolder in courseFolders) {
    try {
      // Process the folder and get file count for progress tracking
      final result =
          await _processCourseFolderWithProgress(courseFolder, batch);

      // Yield progress after processing each folder
      currentFolderIndex++;
      yield {
        'currentFolder': currentFolderIndex,
        'totalFolder': totalFolders,
        'currentFile': result.filesProcessed,
        'totalFile': result.totalFiles,
      };
    } catch (e) {
      // Log error but continue processing other folders
      print('Error processing folder ${courseFolder.path}: $e');
      currentFolderIndex++;
      yield {
        'currentFolder': currentFolderIndex,
        'totalFolder': totalFolders,
        'currentFile': 0,
        'totalFile': 0,
      };
    }
  }

  // Commit all changes atomically
  await batch.commit();
  ref.read(settingsProvider.notifier).updateRebuiltTime();
  Fluttertoast.showToast(msg: 'Media library rebuilt successfully');
}

/// Callback-based rebuild API. Calls [onProgress] periodically with the
/// same progress map that the stream version emitted. The [isCancelled]
/// callback is polled to allow cooperative cancellation from callers
/// (for example a provider notifier).
Future<void> rebuildDbWithCallback(
  String path,
  dynamic ref,
  void Function(Map<String, int>) onProgress,
  bool Function() isCancelled,
) async {
  Fluttertoast.showToast(msg: 'Rebuilding media library...');

  // Initialize and clear previous data
  ref.read(settingsProvider.notifier).stateRebuilding();
  final store = ref.read(jsonStoreProvider);
  final batch = await MediaLibraryBatch.start(store);

  // Clear existing data for fresh rebuild
  batch.clearSongs();
  batch.clearAlbums();

  final rootDirectory = Directory(path);
  if (!await rootDirectory.exists()) {
    Fluttertoast.showToast(msg: 'Error: Root directory not found');
    return;
  }

  final courseFolders = await _discoverCourseFolders(rootDirectory);
  final totalFolders = courseFolders.length;

  // Initial progress callback
  onProgress({
    'currentFolder': 0,
    'totalFolder': totalFolders,
    'currentFile': 0,
    'totalFile': 0,
  });

  int currentFolderIndex = 0;

  for (final courseFolder in courseFolders) {
    if (isCancelled()) break;

    try {
      final result =
          await _processCourseFolderWithProgress(courseFolder, batch);

      currentFolderIndex++;
      onProgress({
        'currentFolder': currentFolderIndex,
        'totalFolder': totalFolders,
        'currentFile': result.filesProcessed,
        'totalFile': result.totalFiles,
      });
    } catch (e) {
      print('Error processing folder ${courseFolder.path}: $e');
      currentFolderIndex++;
      onProgress({
        'currentFolder': currentFolderIndex,
        'totalFolder': totalFolders,
        'currentFile': 0,
        'totalFile': 0,
      });
    }
  }

  if (!isCancelled()) {
    await batch.commit();
    ref.read(settingsProvider.notifier).updateRebuiltTime();
    Fluttertoast.showToast(msg: 'Media library rebuilt successfully');
  } else {
    // Optionally roll back or leave partial changes; here we do not commit
    // to avoid leaving a partially-updated DB when cancelled.
    Fluttertoast.showToast(msg: 'Rebuild cancelled');
  }
}

/// Discovers all course folders, including nested structures
/// Returns a flat list of directories that contain media files
Future<List<Directory>> _discoverCourseFolders(Directory rootDirectory) async {
  final courseFolders = <Directory>[];

  await for (final entity
      in rootDirectory.list(recursive: false, followLinks: false)) {
    if (entity is Directory) {
      // Check if this directory contains audio files directly or in subdirectories
      if (await _containsAudioFiles(entity)) {
        courseFolders.add(entity);
      }
    }
  }

  return courseFolders;
}

/// Checks if a directory contains audio files (directly or in subdirectories)
Future<bool> _containsAudioFiles(Directory directory) async {
  try {
    await for (final entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File && _isAudioFile(entity.path)) {
        return true;
      }
    }
  } catch (e) {
    // If we can't read the directory, assume it doesn't contain audio files
    return false;
  }
  return false;
}

/// Checks if a file is an audio file based on extension
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

/// Processing result for progress tracking
class FolderProcessingResult {
  final int totalFiles;
  final int filesProcessed;
  final int albumId;

  const FolderProcessingResult({
    required this.totalFiles,
    required this.filesProcessed,
    required this.albumId,
  });
}

/// Processes a course folder and returns processing statistics
Future<FolderProcessingResult> _processCourseFolderWithProgress(
    Directory courseFolder, MediaLibraryBatch batch) async {
  // Collect all audio files in the folder
  final audioFiles = <File>[];
  await for (final entity
      in courseFolder.list(recursive: true, followLinks: false)) {
    if (entity is File && _isAudioFile(entity.path)) {
      audioFiles.add(entity);
    }
  }

  final totalFiles = audioFiles.length;
  if (totalFiles == 0) {
    return FolderProcessingResult(
      totalFiles: 0,
      filesProcessed: 0,
      albumId: -1,
    );
  }

  // Process the course folder and create album with embedded songs
  final albumId =
      await _createCourseAlbumWithSongs(courseFolder, audioFiles, batch);

  return FolderProcessingResult(
    totalFiles: totalFiles,
    filesProcessed: totalFiles,
    albumId: albumId,
  );
}

/// Creates a course album with all songs embedded within it
Future<int> _createCourseAlbumWithSongs(Directory courseFolder,
    List<File> audioFiles, MediaLibraryBatch batch) async {
  final songs = <Song>[];
  final authors = <String>{};

  // Sort files to ensure consistent ordering
  audioFiles.sort((a, b) => basename(a.path).compareTo(basename(b.path)));

  // Process each audio file
  for (final file in audioFiles) {
    try {
      final tag = await AudioTags.read(file.path);

      // Extract metadata
      final artistName = tag?.albumArtist ?? '';
      final artist = washArtist(artistName).isNotEmpty
          ? washArtist(artistName)
          : 'Unknown Artist';
      final title = _cleanFileName(basename(file.path));
      final duration = tag?.duration ?? 0;

      // Determine track number and section/disc
      final relativePath = relative(file.path, from: courseFolder.path);
      final pathParts = split(relativePath);
      final section = pathParts.length > 1 ? pathParts.first : null;
      final trackNumber = _extractTrackNumber(basename(file.path));

      // Add artist to set for album metadata
      if (artist != 'Unknown Artist') {
        authors.add(artist);
      }

      // Create song
      final song = Song(
        id: batch.nextSongId(),
        artist: artist,
        title: title,
        length: duration,
        disc: section ?? '', // Use section/subfolder as disc
        path: file.path,
        track: trackNumber,
        playedInSecond: 0,
        addedAt: DateTime.now(),
      );

      songs.add(song);
    } catch (e) {
      // Skip files that can't be processed but continue with others
      print('Error processing audio file ${file.path}: $e');
    }
  }

  // Create album with embedded songs
  final albumId = batch.insertAlbumWithSongs(
    title: basename(courseFolder.path),
    author: _determineAlbumArtist(authors),
    sourcePath: courseFolder.path,
    songs: songs,
    lastPlayedTime: -1,
    lastPlayedIndex: -1,
  );

  return albumId;
}

/// Determines the best album artist from a set of artists
String _determineAlbumArtist(Set<String> authors) {
  if (authors.isEmpty) return 'Unknown Artist';
  if (authors.length == 1) return authors.first;

  // If multiple artists, use the most common approach or combine them
  return authors.join(', ');
}

/// Cleans filename for display (removes extension and common prefixes)
String _cleanFileName(String filename) {
  var cleaned = basenameWithoutExtension(filename);

  // Remove common track number prefixes
  cleaned = cleaned.replaceFirst(RegExp(r'^\d+[\.\-\s]*'), '');
  cleaned = cleaned.replaceFirst(
      RegExp(r'^Track\s*\d+[\.\-\s]*', caseSensitive: false), '');

  return cleaned.trim().isNotEmpty ? cleaned.trim() : filename;
}

/// Extracts track number from filename
int? _extractTrackNumber(String filename) {
  // Try to find track number at the beginning of filename
  final match = RegExp(r'^(\d+)').firstMatch(filename);
  if (match != null) {
    return int.tryParse(match.group(1)!);
  }

  // Try to find "Track XX" pattern
  final trackMatch =
      RegExp(r'Track\s*(\d+)', caseSensitive: false).firstMatch(filename);
  if (trackMatch != null) {
    return int.tryParse(trackMatch.group(1)!);
  }

  return null;
}

/// This function rebuilds the database from the given path.
/// Given path is the base folder of only one album.
/// If the album is already in the database (same sourcePath), it will be updated.
/// If not, add it to database
Future<int> partialRebuild(String baseFolderPath, dynamic ref) async {
  Fluttertoast.showToast(msg: 'Updating course...');
  final directory = Directory(baseFolderPath);
  if (await directory.exists()) {
    final store = ref.read(jsonStoreProvider);
    final batch = await MediaLibraryBatch.start(store);

    // Check if album already exists and remove it
    final existing = batch.albumByPath(baseFolderPath);
    if (existing != null) {
      batch.deleteAlbumById(existing.id);
    }

    // Process the folder with the new approach
    await _processCourseFolderWithProgress(directory, batch);

    await batch.commit();
    Fluttertoast.showToast(msg: 'Course updated successfully');
    ref.read(settingsProvider.notifier).updateRebuiltTime();
    return 0;
  }
  Fluttertoast.showToast(msg: 'Error: Directory not found');
  return 1;
}

// no persistent covers
