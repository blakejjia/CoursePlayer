import 'package:lemon/common/data/models/models.dart';
import 'package:drift/drift.dart';

@DriftAccessor(tables: [Album])
class AlbumRepository extends DatabaseAccessor<AppDatabase> {
  AlbumRepository(super.db);

  /// update last played index with id
  Future<int> updateLastPlayedIndexWithId(int id, int lastPlayedIndex) async {
    return await (update(db.albums)..where((tbl) => tbl.id.equals(id))).write(
        AlbumsCompanion(
            lastPlayedIndex: Value(lastPlayedIndex),
            // TODO: sometimes playedTracks is not lastPlayed index
            playedTracks: Value(lastPlayedIndex)));
  }

  /// insert a new album to the database
  Future<int> insertAlbum(
      {required String title,
      required String author,
      required int imageId,
      required String sourcePath,
      required int lastPlayedTime,
      required int totalTracks,
      required int playedTracked,
      required int lastPlayedIndex}) async {
    return await into(db.albums).insert(
      AlbumsCompanion(
        title: Value(title),
        author: Value(author),
        imageId: Value(imageId),
        sourcePath: Value(sourcePath),
        lastPlayedTime: Value(lastPlayedTime),
        lastPlayedIndex: Value(lastPlayedIndex),
        totalTracks: Value(totalTracks),
        playedTracks: Value(playedTracked),
      ),
    );
  }

  /// get all albums from the database
  Future<List<Album>> getAllAlbums() async {
    return await select(db.albums).get();
  }

  /// destroy the album database
  Future<int> destroyAlbumDb() => db.delete(db.albums).go();

  /// get album by name
  Future<Album?> getAlbumByName(String name) async {
    return await (select(db.albums)..where((tbl) => tbl.title.equals(name)))
        .getSingleOrNull();
  }

  /// get album by id
  Future<Album?> getAlbumById(int id) async {
    return await (select(db.albums)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// delete album
  Future<int> deleteAlbum(int id) async {
    return await (delete(db.albums)..where((tbl) => tbl.id.equals(id))).go();
  }
}
