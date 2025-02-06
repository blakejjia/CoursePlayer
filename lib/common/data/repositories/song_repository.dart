import 'package:lemon/common/data/models/models.dart';
import 'package:drift/drift.dart';

@DriftAccessor(tables: [Songs])
class SongRepository extends DatabaseAccessor<AppDatabase> {
  SongRepository(super.db);

  // 创建新歌曲
  Future<int> insertSong({
    required String artist,
    required String title,
    required String album,
    required int length,
    required int imageId,
    required String path,
    required String parts,
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
        parts: Value(parts),
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

  // update
  Future<bool> updateSong(Song song) => db.update(db.songs).replace(song);
  // delete
  Future<int> deleteSong(int id) =>
      (db.delete(db.songs)..where((s) => s.id.equals(id))).go();
  // destroy
  Future<int> destroySongDb() => db.delete(db.songs).go();

  // query song by playlist name
  Future<List<Song>> getSongByPlaylist(String playlistName) async {
    return await (db.select(db.songs)
          ..where((tbl) => tbl.album.equals(playlistName)))
        .get();
  }
}
