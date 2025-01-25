import 'package:lemon/common/data/models/models.dart';
import 'package:drift/drift.dart';

@DriftAccessor(tables: [Playlists])
class PlaylistRepository extends DatabaseAccessor<AppDatabase>{
  PlaylistRepository(super.db);

  // 创建新的播放列表
  Future<int> insertPlaylist(String title, String author, int imageId) async {
    return await into(db.playlists).insert(
      PlaylistsCompanion(
        title: Value(title),
        author: Value(author),
        imageId: Value(imageId),
      ),
    );
  }

  // 获取所有播放列表
  Future<List<Playlist>> getAllPlaylists() async {
    return await select(db.playlists).get();
  }

  Future<int> destroyPlaylistDb() => db.delete(db.playlists).go();

  Future<Playlist?> getPlaylistByName(String name) async {
    return await (select(db.playlists)..where((tbl) => tbl.title.equals(name))).getSingleOrNull();
  }

  Future<Playlist?> getPlaylistById(int id) async {
    return await (select(db.playlists)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // 删除播放列表
  Future<int> deletePlaylist(int id) async {
    return await (delete(db.playlists)..where((tbl) => tbl.id.equals(id))).go();
  }
}