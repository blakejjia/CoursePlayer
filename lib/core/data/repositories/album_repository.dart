import 'package:lemon/core/data/repositories/storage.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AlbumRepository {
  final MediaLibraryStore store;
  final Ref? ref;
  AlbumRepository(this.store, {this.ref});

  /// --------------- insert ---------------------
  Future<String> insertAlbum({
    required String title,
    required String author,
    required String sourcePath,
    required List<Song> songs,
  }) async {
    final root = await store.load();
    final nextId = Uuid().v4();
    final dto = Album(
      id: nextId,
      title: title,
      author: author,
      sourcePath: sourcePath,
      songs: songs,
    );
    final next = root.copyWith(albums: [...root.albums, dto]);
    await store.replace(next);
    return nextId;
  }

  ///  ------------------ get -----------------------
  Future<List<Album>> get albums async {
    final root = await store.load();
    return root.albums;
  }

  Future<List<Album>> getAlbumsByLastPlayedTime() async {
    final root = await store.load();
    final list = [...root.albums];
    list.sort(
        (a, b) => (b.lastPlayedTime ?? 0).compareTo(a.lastPlayedTime ?? 0));
    return list;
  }

  Future<Album?> getAlbumById(String id) async {
    final root = await store.load();
    final dto = root.albums.where((e) => e.id == id).cast<Album?>().firstWhere(
          (e) => e != null,
          orElse: () => null,
        );
    return dto;
  }

  Future<Album?> getAlbumByPath(String path) async {
    final root = await store.load();
    final dto = root.albums
        .where((e) => e.sourcePath == path)
        .cast<Album?>()
        .firstWhere(
          (e) => e != null,
          orElse: () => null,
        );
    return dto;
  }

  /// ------------------------ delete ------------------------
  Future<int> deleteAlbumById(String id) async {
    final root = await store.load();
    final before = root.albums.length;
    final list = root.albums.where((e) => e.id != id).toList();
    if (list.length == before) return 0;
    await store.replace(root.copyWith(albums: list));
    return 1;
  }

  Future<int> clearAlbums() async {
    final root = await store.load();
    await store.replace(root.copyWith(albums: const []));
    return 1;
  }

  /// ======================= business logic =========================
  /// Update song progress within an album
  Future<int> updateSongProgress(
      String albumId, String songId, int progress) async {
    final root = await store.load();
    final albums = [...root.albums];
    final albumIndex = albums.indexWhere((a) => a.id == albumId);
    if (albumIndex == -1) return 0;
    final album = albums[albumIndex];
    final songs = [...album.songs];
    final songIndex = songs.indexWhere((s) => s.id == songId);
    if (songIndex == -1) return 0;
    final song = songs[songIndex];
    final updatedSong = song.copyWith(
      playedInSecond: progress,
      lastPlayed: DateTime.now(),
    );
    songs[songIndex] = updatedSong;
    final updatedAlbum = album.copyWith(songs: songs);
    albums[albumIndex] = updatedAlbum;
    await store.replace(root.copyWith(albums: albums));
    return 1;
  }
}
