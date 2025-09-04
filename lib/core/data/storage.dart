import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'models/models.dart';

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

  // Covers are loaded on demand from audio files; nothing persisted here.
}

/// Batch editor that groups multiple changes into a single load+save cycle.
class MediaLibraryBatch {
  final MediaLibraryStore _store;
  MediaLibraryFileRoot _root;
  bool _committed = false;
  List<Album> get albums => _root.albums;

  MediaLibraryBatch._(this._store, this._root);

  MediaLibraryFileRoot get root => _root;

  /// Start a batch on top of current store contents.
  static Future<MediaLibraryBatch> start(MediaLibraryStore store) async {
    final root = await store.load();
    // work on a local copy to avoid readers seeing partial updates
    final copy = root.copyWith(
      albums: List.of(root.albums),
      songs: List.of(root.songs),
    );
    return MediaLibraryBatch._(store, copy);
  }

  /// Commit all staged changes back to the store (single write).
  Future<void> commit() async {
    if (_committed) return;
    await _store.replace(_root);
    _committed = true;
  }

  // ---------------- Album helpers ----------------
  int nextAlbumId() {
    if (_root.albums.isEmpty) return 1;
    final maxId = _root.albums.map((e) => e.id).reduce(math.max);
    return maxId + 1;
  }

  int insertAlbum({
    int? id,
    required String title,
    required String author,
    required String sourcePath,
    required int lastPlayedTime,
    required int totalTracks,
    required int playedTracked,
    required int lastPlayedIndex,
  }) {
    final assigned = id ?? nextAlbumId();
    final dto = Album(
      id: assigned,
      title: title,
      author: author,
      sourcePath: sourcePath,
      lastPlayedTime: lastPlayedTime,
      lastPlayedIndex: lastPlayedIndex,
      totalTracks: totalTracks,
      playedTracks: playedTracked,
    );
    _root = _root.copyWith(albums: [..._root.albums, dto]);
    return assigned;
  }

  /// Inserts an album with embedded songs - the new preferred method
  int insertAlbumWithSongs({
    int? id,
    required String title,
    required String author,
    required String sourcePath,
    required List<Song> songs,
  }) {
    final assigned = id ?? nextAlbumId();
    final dto = Album(
      id: assigned,
      title: title,
      author: author,
      sourcePath: sourcePath,
      totalTracks: songs.length,
      playedTracks: 0,
      songs: songs,
    );
    _root = _root.copyWith(albums: [..._root.albums, dto]);
    return assigned;
  }

  Album? albumByPath(String path) {
    try {
      return _root.albums.firstWhere((a) => a.sourcePath == path);
    } catch (_) {
      return null;
    }
  }

  void deleteAlbumById(int id) {
    _root = _root.copyWith(
      albums: _root.albums.where((e) => e.id != id).toList(),
    );
  }

  void clearAlbums() {
    _root = _root.copyWith(albums: const []);
  }

  // ---------------- Song helpers ----------------
  int nextSongId() {
    if (_root.songs.isEmpty) return 1;
    final maxId = _root.songs.map((e) => e.id).reduce(math.max);
    return maxId + 1;
  }

  int insertSong({
    required String artist,
    required String title,
    required int albumId,
    required int length,
    required String path,
    String? parts,
    required int playedInSecond,
  }) {
    final id = nextSongId();
    final dto = Song(
      id: id,
      artist: artist,
      title: title,
      length: length,
      path: path,
      disc: parts ?? '',
      track: null,
      playedInSecond: playedInSecond,
    );
    _root = _root.copyWith(songs: [..._root.songs, dto]);
    return id;
  }

  void clearSongs() {
    _root = _root.copyWith(songs: const []);
  }
}
