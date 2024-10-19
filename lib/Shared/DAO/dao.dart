import 'package:course_player/Shared/DAO/models.dart';
import 'package:drift/drift.dart';

@DriftAccessor(tables: [Songs])
class SongDAO extends DatabaseAccessor<AppDatabase>{
  SongDAO(super.db);

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

@DriftAccessor(tables: [Covers])
class CoversDao extends DatabaseAccessor<AppDatabase>{
  CoversDao(super.db);

  // 创建新封面
  Future<int> createCover(Uint8List coverData, String hash) async {
    return await into(db.covers).insert(
      CoversCompanion(
        cover: Value(coverData),
        hash: Value(hash),
      ),
    );
  }

  // 创建新封面 withId
  Future<int> createCoverWithId(int id,Uint8List coverData, String hash) async {
    return await into(db.covers).insert(
      CoversCompanion(
        id: Value(id),
        cover: Value(coverData),
        hash: Value(hash),
      ),
    );
  }

  // 根据ID读取封面
  Future<Cover?> getCoverById(int id) async {
    return await (select(db.covers)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

// 根据哈希值读取封面的 ID
  Future<int?> getCoverIdByHash(String hash) async {
    final result = await (select(db.covers)..where((tbl) => tbl.hash.equals(hash))).getSingleOrNull();
    return result?.id; // 假设 Cover 类中有一个 id 字段
  }


// 更新封面
  Future<bool> updateCover(int id, Uint8List newCoverData, String newHash) async {
    final coverToUpdate = await getCoverById(id);
    if (coverToUpdate != null) {
      final rowsAffected = await (update(db.covers)..where((tbl) => tbl.id.equals(id))).write(
        CoversCompanion(
          cover: Value(newCoverData),
          hash: Value(newHash),
        ),
      );
      return rowsAffected > 0; // 返回更新是否成功的布尔值
    }
    return false; // 封面未找到
  }

  // 删除封面
  Future<int> deleteCover(int id) async {
    return await (delete(db.covers)..where((tbl) => tbl.id.equals(id))).go();
  }

  // 获取所有封面
  Future<List<Cover>> getAllCovers() async {
    return await select(db.covers).get();
  }

  Future<int> destroyCoversDb() => db.delete(db.covers).go();
}


@DriftAccessor(tables: [Playlists])
class PlaylistsDao extends DatabaseAccessor<AppDatabase>{
  PlaylistsDao(super.db);

  // 创建新的播放列表
  Future<int> createPlaylist(String title, String author, int imageId) async {
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

  // 根据 ID 获取播放列表
  Future<Playlist?> getPlaylistById(int id) async {
    return await (select(db.playlists)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // 删除播放列表
  Future<int> deletePlaylist(int id) async {
    return await (delete(db.playlists)..where((tbl) => tbl.id.equals(id))).go();
  }
}