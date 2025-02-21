import 'package:lemon/common/data/models/models.dart';
import 'package:drift/drift.dart';

@DriftAccessor(tables: [Album])
class AlbumRepository extends DatabaseAccessor<AppDatabase> {
  AlbumRepository(super.db);

  /// update last played index with id
  Future<int> updateLastPlayedTimeWithId(int id) async {
    int timestamp = double.parse(DateTime.timestamp().toString()).round();
    return await (update(db.albums)..where((tbl) => tbl.id.equals(id)))
        .write(AlbumsCompanion(lastPlayedTime: Value(timestamp)));
  }

  /// update last played index with id
  Future<void> updateLastPlayedSongWithId(int id, int songId) async {
    await (update(db.albums)..where((tbl) => tbl.id.equals(id)))
        .write(AlbumsCompanion(lastPlayedIndex: Value(songId)));
  }

  /// updateAlbumProgress
  Future<int> updateAlbumProgress(Album album) async {
    final songs = await (select(db.songs)
          ..where((tbl) => tbl.album.equals(album.id)))
        .get();
    int playedTracks = 0;

    for (var song in songs) {
      if (song.playedInSecond / song.length > 0.9) {
        playedTracks++;
      }
    }

    return await (update(db.albums)..where((tbl) => tbl.id.equals(album.id)))
        .write(
      AlbumsCompanion(
        playedTracks: Value(playedTracks),
      ),
    );
  }

  /// Update all album progress
  Future<int> updateAllAlbumProgress() async {
    final albums = await getAllAlbums();
    int updatedCount = 0;

    for (var album in albums) {
      await updateAlbumProgress(album);
      updatedCount++;
    }

    return updatedCount;
  }

  /// insert a new album to the database
  Future<int> insertAlbum(
      {int? id,
      required String title,
      required String author,
      required int imageId,
      required String sourcePath,
      required int lastPlayedTime,
      required int totalTracks,
      required int playedTracked,
      required int lastPlayedIndex}) async {
    return await into(db.albums).insert(
      (id != null)
          ? AlbumsCompanion(
              id: Value(id),
              title: Value(title),
              author: Value(author),
              imageId: Value(imageId),
              sourcePath: Value(sourcePath),
              lastPlayedTime: Value(lastPlayedTime),
              lastPlayedIndex: Value(lastPlayedIndex),
              totalTracks: Value(totalTracks),
              playedTracks: Value(playedTracked),
            )
          : AlbumsCompanion(
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
