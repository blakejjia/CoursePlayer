import 'package:lemon/core/data/storage.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlbumRepository {
  final MediaLibraryStore store;
  final Ref? ref;
  AlbumRepository(this.store, {this.ref});

  /// update last played time with id
  Future<int> updateLastPlayedTimeWithId(int id) async {
    final root = await store.load();
    final idx = root.albums.indexWhere((e) => e.id == id);
    if (idx < 0) return 0;
    final ts = DateTime.now().millisecondsSinceEpoch;
    final updated = root.albums[idx].copyWith(lastPlayedTime: ts);
    final list = [...root.albums];
    list[idx] = updated;
    await store.replace(root.copyWith(albums: list));
    return 1;
  }

  /// update last played song with id
  Future<void> updateLastPlayedSongWithId(int id, int songId) async {
    final root = await store.load();
    final idx = root.albums.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final updated = root.albums[idx].copyWith(lastPlayedIndex: songId);
    final list = [...root.albums];
    list[idx] = updated;
    await store.replace(root.copyWith(albums: list));
  }

  /// updateAlbumProgress
  Future<int> updateAlbumProgress(Album album) async {
    final root = await store.load();
    final albumIdx = root.albums.indexWhere((e) => e.id == album.id);
    if (albumIdx < 0) return 0;

    final currentAlbum = root.albums[albumIdx];
    final songs = currentAlbum.songs ?? [];
    int playedTracks = 0;
    for (final s in songs) {
      final playedRatio = (s.playedInSecond ?? 0) / s.length;
      if (s.length > 0 && playedRatio > 0.9) {
        playedTracks++;
      }
    }

    final updated = currentAlbum.copyWith(playedTracks: playedTracks);
    final list = [...root.albums];
    list[albumIdx] = updated;
    await store.replace(root.copyWith(albums: list));
    return 1;
  }

  /// insert
  Future<int> insertAlbum({
    int? id,
    required String title,
    required String author,
    required String sourcePath,
    required int lastPlayedTime,
    required int totalTracks,
    required int playedTracked,
    required int lastPlayedIndex,
  }) async {
    final root = await store.load();
    final nextId = id ??
        ((root.albums.isEmpty)
            ? 1
            : (root.albums.map((e) => e.id).reduce((a, b) => a > b ? a : b) +
                1));
    final dto = Album(
      id: nextId,
      title: title,
      author: author,
      sourcePath: sourcePath,
      lastPlayedTime: lastPlayedTime,
      lastPlayedIndex: lastPlayedIndex,
      totalTracks: totalTracks,
      playedTracks: playedTracked,
    );
    final next = root.copyWith(albums: [...root.albums, dto]);
    await store.replace(next);
    return nextId;
  }

  ///  ------------------ get -----------------------
  Future<List<Album>> getAlbumsByLastPlayedTime() async {
    final root = await store.load();
    final list = [...root.albums];
    list.sort(
        (a, b) => (b.lastPlayedTime ?? 0).compareTo(a.lastPlayedTime ?? 0));
    return list;
  }

  Future<Album?> getAlbumById(int id) async {
    final root = await store.load();
    final dto = root.albums.where((e) => e.id == id).cast<Album?>().firstWhere(
          (e) => e != null,
          orElse: () => null,
        );
    return dto;
  }

  Future<Album?> getAlbumIdByPath(String path) async {
    final root = await store.load();
    final dto = root.albums
        .where((e) => e.sourcePath == path)
        .cast<Album?>()
        .firstWhere((e) => e != null, orElse: () => null);
    return dto;
  }

  Future<Album?> getAlbumByName(String name) async {
    final root = await store.load();
    final dto = root.albums
        .where((e) => e.title == name)
        .cast<Album?>()
        .firstWhere((e) => e != null, orElse: () => null);
    return dto;
  }

  Future<int> getNextAlbumId() async {
    final root = await store.load();
    if (root.albums.isEmpty) return 0;
    final maxId = root.albums.map((e) => e.id).reduce((a, b) => a > b ? a : b);
    return maxId;
  }

  /// ------------------------ delete ------------------------
  Future<int> deleteAlbumById(int id) async {
    final root = await store.load();
    final before = root.albums.length;
    final list = root.albums.where((e) => e.id != id).toList();
    if (list.length == before) return 0;
    await store.replace(root.copyWith(albums: list));
    return 1;
  }

  Future<int> destroyAlbumDb() async {
    final root = await store.load();
    await store.replace(root.copyWith(albums: const []));
    return 1;
  }
}
