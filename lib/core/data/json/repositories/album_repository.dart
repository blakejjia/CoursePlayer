import 'package:lemon/core/data/json/utils/media_library_store.dart';
import 'package:lemon/core/data/json/models/media_library_schema.dart';
import 'package:lemon/core/data/json/models/models.dart' show Album;

class AlbumRepository {
  final MediaLibraryStore store;
  AlbumRepository(this.store);

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
    final songs = root.songs.where((s) => s.album == album.id);
    int playedTracks = 0;
    for (final s in songs) {
      if (s.length > 0 && s.playedInSecond / s.length > 0.9) {
        playedTracks++;
      }
    }
    final idx = root.albums.indexWhere((e) => e.id == album.id);
    if (idx < 0) return 0;
    final updated = root.albums[idx].copyWith(playedTracks: playedTracks);
    final list = [...root.albums];
    list[idx] = updated;
    await store.replace(root.copyWith(albums: list));
    return 1;
  }

  /// insert
  Future<int> insertAlbum({
    int? id,
    required String title,
    required String author,
    required int imageId,
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
    final dto = AlbumDto(
      id: nextId,
      title: title,
      author: author,
      imageId: 0,
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
    final list = root.albums.map(_toAlbum).toList()
      ..sort((a, b) => b.lastPlayedTime.compareTo(a.lastPlayedTime));
    return list;
  }

  Future<Album?> getAlbumById(int id) async {
    final root = await store.load();
    final dto =
        root.albums.where((e) => e.id == id).cast<AlbumDto?>().firstWhere(
              (e) => e != null,
              orElse: () => null,
            );
    return dto == null ? null : _toAlbum(dto);
  }

  Future<Album?> getAlbumIdByPath(String path) async {
    final root = await store.load();
    final dto = root.albums
        .where((e) => e.sourcePath == path)
        .cast<AlbumDto?>()
        .firstWhere((e) => e != null, orElse: () => null);
    return dto == null ? null : _toAlbum(dto);
  }

  Future<Album?> getAlbumByName(String name) async {
    final root = await store.load();
    final dto = root.albums
        .where((e) => e.title == name)
        .cast<AlbumDto?>()
        .firstWhere((e) => e != null, orElse: () => null);
    return dto == null ? null : _toAlbum(dto);
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

  // Mapping
  Album _toAlbum(AlbumDto dto) => Album(
        id: dto.id,
        title: dto.title,
        author: dto.author,
        imageId: 0,
        sourcePath: dto.sourcePath,
        lastPlayedTime: dto.lastPlayedTime,
        lastPlayedIndex: dto.lastPlayedIndex,
        totalTracks: dto.totalTracks,
        playedTracks: dto.playedTracks,
      );
}
