
import 'package:course_player/data/models/models.dart';
import 'package:drift/drift.dart';

@DriftAccessor(tables: [Songs])
class SongRepository extends DatabaseAccessor<AppDatabase>{
  SongRepository(super.db);

  // 创建新歌曲
  Future<int> insertSong({
    required String artist,
    required String title,
    required String playlist,
    required int length,
    required int imageId,
    required String path,
  }) async {
    return await into(db.songs).insert(
      SongsCompanion(
        artist: Value(artist),
        title: Value(title),
        playlist: Value(playlist),
        length: Value(length),
        imageId: Value(imageId),
        path: Value(path),
      ),
    );
  }

  // read
  Future<List<Song>> getAllSongs() => db.select(db.songs).get();
  // update
  Future<bool> updateSong(Song song) => db.update(db.songs).replace(song);
  // delete
  Future<int> deleteSong(int id) => (db.delete(db.songs)..where((s) => s.id.equals(id))).go();
  // destroy
  Future<int> destroySongDb() => db.delete(db.songs).go();

  // query song by playlist name
  Future<List<Song>> getSongByPlaylist(String playlistName) async{
    return await (db.select(db.songs)..where((tbl) => tbl.playlist.equals(playlistName))).get();
  }
}
