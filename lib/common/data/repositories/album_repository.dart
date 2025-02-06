import 'package:lemon/common/data/models/models.dart';
import 'package:drift/drift.dart';

@DriftAccessor(tables: [Album])
class AlbumRepository extends DatabaseAccessor<AppDatabase>{
  AlbumRepository(super.db);

  // 创建新的播放列表
  Future<int> insertAlbum({required String title,required String author,required int imageId,
  required String sourcePath, required int lastPlayedTime, required int totalTracks, required int playedTracked,
  required int lastPlayedIndex}) async {
    return await into(db.albums).insert(
      AlbumsCompanion(
        title: Value(title),
        author: Value(author),
        imageId: Value(imageId),
        sourcePath: Value(sourcePath),
        lastPlayedTime: Value(lastPlayedTime),
        lastPlayedIndex: Value(lastPlayedTime),
        totalTracks: Value(totalTracks),
        playedTracks: Value(playedTracked),
      ),
    );
  }

  // 获取所有播放列表
  Future<List<Album>> getAllAlbums() async {
    return await select(db.albums).get();
  }

  Future<int> destroyAlbumDb() => db.delete(db.albums).go();

  Future<Album?> getAlbumByName(String name) async {
    return await (select(db.albums)..where((tbl) => tbl.title.equals(name))).getSingleOrNull();
  }

  Future<Album?> getAlbumById(int id) async {
    return await (select(db.albums)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // 删除播放列表
  Future<int> deleteAlbum(int id) async {
    return await (delete(db.albums)..where((tbl) => tbl.id.equals(id))).go();
  }
}