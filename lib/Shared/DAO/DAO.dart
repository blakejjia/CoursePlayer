import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/main.dart';


class SongDAO{
  final AppDatabase db = getIt<AppDatabase>();

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
}

class ImageDAO{
  final AppDatabase db = getIt<AppDatabase>();

  Future<int> insertImage(ImagesCompanion image) => db.into(db.images).insert(image);

}