import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/models.dart';

/// Handles reading/writing MediaLibrary.json with atomic writes.
class MediaLibraryStore {
  final String jsonFileName;
  // Covers are not persisted; load dynamically on demand.

  MediaLibraryFileRoot _cache = MediaLibraryFileRoot.empty();
  bool _loaded = false;
  final _changes = StreamController<MediaLibraryFileRoot>.broadcast();
  Completer<void>? _writeLock;

  MediaLibraryStore({
    this.jsonFileName = 'MediaLibrary.json',
  });

  Stream<MediaLibraryFileRoot> get changes => _changes.stream;

  Future<File> _jsonFile() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, jsonFileName));
  }

  /// Load JSON from disk into memory. Creates an empty one if missing or invalid.
  Future<MediaLibraryFileRoot> load() async {
    if (_loaded) return _cache;
    final file = await _jsonFile();
    try {
      if (await file.exists()) {
        final text = await file.readAsString();
        _cache = MediaLibraryFileRoot.decode(text);
      } else {
        _cache = MediaLibraryFileRoot.empty();
        await save();
      }
      _loaded = true;
      return _cache;
    } catch (e) {
      // backup corrupted file and start fresh
      try {
        if (await file.exists()) {
          final backupPath =
              '${file.path}.bak-${DateTime.now().millisecondsSinceEpoch}';
          await file.copy(backupPath);
        }
      } catch (_) {}
      _cache = MediaLibraryFileRoot.empty();
      _loaded = true;
      await save();
      return _cache;
    }
  }

  /// Save the in-memory cache to disk atomically.
  Future<void> save() async {
    // serialize writes
    while (_writeLock != null) {
      await _writeLock!.future;
    }
    _writeLock = Completer<void>();
    try {
      final file = await _jsonFile();
      final bytes = utf8.encode(_cache.encode());
      await file.writeAsBytes(bytes, flush: true);
      _changes.add(_cache);
    } finally {
      _writeLock!.complete();
      _writeLock = null;
    }
  }

  /// Replace entire library and persist.
  Future<void> replace(MediaLibraryFileRoot next) async {
    _cache = next.copyWith(
      generatedAt: DateTime.now().toIso8601String(),
    );
    await save();
  }

  /// Force reload from disk (useful for file watchers)
  Future<MediaLibraryFileRoot> forceReload() async {
    _loaded = false;
    _cache = MediaLibraryFileRoot.empty();
    final newData = await load();
    _changes.add(newData);
    return newData;
  }
}
