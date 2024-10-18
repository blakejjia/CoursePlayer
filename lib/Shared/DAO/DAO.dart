import 'package:course_player/Shared/DAO/models.dart';
import 'package:get_it/get_it.dart';


class SongDAO{
  final AppDatabase db =  GetIt.I<AppDatabase>();

  // create
  Future<int> insertSong(SongsCompanion song) => db.into(db.songs).insert(song);
  // read
  Future<List<Song>> getAllSongs() => db.select(db.songs).get();
  // update
  Future<bool> updateSong(Song song) => db.update(db.songs).replace(song);
  // delete
  Future<int> deleteSong(int id) => (db.delete(db.songs)..where((s) => s.id.equals(id))).go();
  // destroy
  Future<int> destroySongDb() => db.delete(db.songs).go();
  // query for all playlists
  Future<List<String?>> getPlaylists() async{
    final query = db.selectOnly(db.songs, distinct: true)..addColumns([db.songs.playlist]);
    final result = await query.map((row) => row.read(db.songs.playlist)).get();

    return result;
  }
  // query song by playlist name
  Future<List<Song>> getSongByPlaylist(String playlistName) async{
    return await (db.select(db.songs)..where((tbl) => tbl.playlist.equals(playlistName))).get();
  }
}

class ImageDAO{
  final AppDatabase db = GetIt.I<AppDatabase>();

  Future<int> insertImage(CoversCompanion image) => db.into(db.covers).insert(image);

}