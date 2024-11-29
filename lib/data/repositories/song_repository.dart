import 'package:hive/hive.dart';
import 'package:course_player/data/models/models.dart';

class SongRepository {
  final Box<Song> _songBox;

  // Constructor
  SongRepository(this._songBox);

  // 创建新歌曲
  Future<void> insertSong({
    required String artist,
    required String title,
    required String playlistId, // 改为 String 类型
    required int length,
    required int imageId,
    required String path,
  }) async {
    final song = Song((b) => b
      ..artist = artist
      ..title = title
      ..playlist = playlistId // 使用 String 类型的 playlistId
      ..length = length
      ..imageId = imageId
      ..path = path);

    await _songBox.add(song); // Add a new song with an auto-generated key
  }

  // 获取所有歌曲
  Future<List<Song>> getAllSongs() async {
    return _songBox.values.toList();
  }

  // 根据ID读取歌曲
  Future<Song?> getSongById(int id) async {
    return _songBox.get(id);
  }

  // 更新歌曲
  Future<bool> updateSong(Song song) async {
    final existingSong = await getSongById(song.id); // Use song.id, not playlistId
    if (existingSong != null) {
      await _songBox.put(song.id, song); // Update song by its ID
      return true; // Successfully updated
    }
    return false; // Song not found
  }

  // 删除歌曲
  Future<void> deleteSong(int id) async {
    await _songBox.delete(id); // Delete the song by its ID
  }

  // 销毁所有歌曲
  Future<void> destroySongDb() async {
    await _songBox.clear(); // Delete all songs
  }

  // 根据播放列表ID获取歌曲
  Future<List<Song>> getSongByPlaylist(String playlistId) async {  // 改为 String 类型
    return _songBox.values
        .where((song) => song.playlist == playlistId) // 使用 String 类型的 playlistId
        .toList();
  }
}
