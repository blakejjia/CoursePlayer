import 'package:lemon/core/backEnd/json/media_library_store.dart';
import 'package:lemon/core/backEnd/json/media_library_schema.dart';
import 'package:lemon/core/backEnd/json/models.dart' show Song; // plain model

import '../wash_data.dart';
import 'package:lemon/main.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';

class SongRepository {
  final MediaLibraryStore store;
  SongRepository(this.store);

  // 创建新歌曲
  Future<int> insertSong({
    required String artist,
    required String title,
    required int album,
    required int length,
    required int imageId,
    required String path,
    String? parts,
    required int playedInSecond,
  }) async {
    final root = await store.load();
    final nextId = (root.songs.isEmpty)
        ? 1
        : (root.songs.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);
    final dto = SongDto(
      id: nextId,
      artist: artist,
      title: title,
      album: album,
      length: length,
      imageId: 0, // imageId not used in JSON backend
      path: path,
      parts: parts ?? '',
      track: null,
      playedInSecond: playedInSecond,
    );
    final next = root.copyWith(songs: [...root.songs, dto]);
    await store.replace(next);
    return nextId;
  }

  // read
  Future<List<Song>> getAllSongs() async {
    final root = await store.load();
    return _handleSongs(root.songs.map(_toSong).toList());
  }

  Future<Song?> getSongById(int id) async {
    final root = await store.load();
    final dto = root.songs.where((e) => e.id == id).cast<SongDto?>().firstWhere(
          (e) => e != null,
          orElse: () => null,
        );
    return dto == null ? null : _toSong(dto);
  }

  Future<List<Song>?> getSongsByAlbumId(int id) async {
    if (id == 0) return null;
    final root = await store.load();
    final songs = root.songs.where((e) => e.album == id).map(_toSong).toList();
    return _handleSongs(songs);
  }

  /// Core sorting + cleaning function
  List<Song> _handleSongs(List<Song> songs) {
    sortSongs(songs);
    final settings = providerContainer.read(settingsProvider);
    if (settings.cleanFileName) {
      return cleanSongTitles(songs);
    }
    return songs;
  }

  // update
  Future<int> updateSongProgress(int id, int playedInSecond) async {
    final root = await store.load();
    final idx = root.songs.indexWhere((e) => e.id == id);
    if (idx < 0) return 0;
    final updated = root.songs[idx].copyWith(playedInSecond: playedInSecond);
    final list = [...root.songs];
    list[idx] = updated;
    await store.replace(root.copyWith(songs: list));
    return 1;
  }

  Future<int> updateSongTrack(int id, int track) async {
    final root = await store.load();
    final idx = root.songs.indexWhere((e) => e.id == id);
    if (idx < 0) return 0;
    final updated = root.songs[idx].copyWith(track: track);
    final list = [...root.songs];
    list[idx] = updated;
    await store.replace(root.copyWith(songs: list));
    return 1;
  }

  /// -------------- delete ----------------
  Future<int> deleteSong(int id) async {
    final root = await store.load();
    final before = root.songs.length;
    final list = root.songs.where((e) => e.id != id).toList();
    if (list.length == before) return 0;
    await store.replace(root.copyWith(songs: list));
    return 1;
  }

  Future<int> destroySongDb() async {
    final root = await store.load();
    await store.replace(root.copyWith(songs: const []));
    return 1;
  }

  Future<int> deleteSongsByAlbumId(int id) async {
    final root = await store.load();
    final before = root.songs.length;
    final list = root.songs.where((e) => e.album != id).toList();
    if (list.length == before) return 0;
    await store.replace(root.copyWith(songs: list));
    return before - list.length;
  }

  // Mapping
  Song _toSong(SongDto dto) => Song(
        id: dto.id,
        artist: dto.artist,
        title: dto.title,
        length: dto.length,
        imageId: 0,
        album: dto.album,
        parts: dto.parts,
        track: dto.track,
        path: dto.path,
        playedInSecond: dto.playedInSecond,
      );
}
