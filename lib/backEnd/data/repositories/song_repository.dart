import 'package:lemon/backEnd/data/models/models.dart';
import 'package:drift/drift.dart';

import '../../../main.dart';
import '../../../frontEnd/pages/settingsPage/bloc/settings_cubit.dart';
import '../../wash_data.dart';

@DriftAccessor(tables: [Songs])
class SongRepository extends DatabaseAccessor<AppDatabase> {
  SongRepository(super.db);

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
    return await into(db.songs).insert(
      SongsCompanion(
        artist: Value(artist),
        title: Value(title),
        album: Value(album),
        length: Value(length),
        imageId: Value(imageId),
        path: Value(path),
        parts: Value(parts ?? ''),
        playedInSecond: Value(playedInSecond),
      ),
    );
  }

  // read
  Future<List<Song>> getAllSongs() => db.select(db.songs).get();
  Future<Song?> getSongById(int id) async {
    return await (db.select(db.songs)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Song>?> getSongsByAlbumId(int id) async {
    if (id == 0) return null;
    List<Song> songs =
        await (db.select(db.songs)..where((tbl) => tbl.album.equals(id))).get();
    return _handleSongs(songs);
  }

  /// Core sorting function
  List<Song> _handleSongs(List<Song> songs) {
    sortSongs(songs);
    if (getIt<SettingsCubit>().state.cleanFileName) {
      List<Song> cleanedSongList = cleanSongTitles(songs);
      return cleanedSongList;
    }
    return songs;
  }

  // update
  Future<int> updateSongProgress(int id, int playedInSecond) =>
      (db.update(db.songs)..where((s) => s.id.equals(id)))
          .write(SongsCompanion(playedInSecond: Value(playedInSecond)));
  Future<int> updateSongTrack(int id, int track) =>
      (db.update(db.songs)..where((s) => s.id.equals(id)))
          .write(SongsCompanion(track: Value(track)));

  /// -------------- delete ----------------
  Future<int> deleteSong(int id) =>
      (db.delete(db.songs)..where((s) => s.id.equals(id))).go();
  Future<int> destroySongDb() => db.delete(db.songs).go();
  Future<int> deleteSongsByAlbumId(int id) =>
      (db.delete(db.songs)..where((s) => s.album.equals(id))).go();
}
