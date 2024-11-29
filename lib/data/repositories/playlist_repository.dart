import 'package:hive/hive.dart';
import 'package:course_player/data/models/models.dart';

class PlaylistRepository {
  final Box<Playlist> _playlistBox;

  // Constructor
  PlaylistRepository(this._playlistBox);

  // 创建新的播放列表
  Future<void> createPlaylist(String title, String author, int imageId) async {
    final playlist = Playlist((b) => b
      ..title = title
      ..author = author
      ..imageId = imageId);
    await _playlistBox.add(playlist); // 添加新的播放列表
  }

  // 获取所有播放列表
  Future<List<Playlist>> getAllPlaylists() async {
    return _playlistBox.values.toList(); // 返回所有播放列表
  }

  // 删除所有播放列表
  Future<void> destroyPlaylistDb() async {
    await _playlistBox.clear(); // 清空所有播放列表
  }

  // 根据名称获取播放列表
  Future<Playlist?> getPlaylistByName(String name) async {
    for (var playlist in _playlistBox.values) {
      if (playlist.title == name) {
        return playlist; // 返回匹配名称的播放列表
      }
    }
    return null; // 如果没有找到，返回 null
  }

  // 根据ID获取播放列表
  Future<Playlist?> getPlaylistById(int id) async {
    return _playlistBox.get(id); // 根据ID获取播放列表
  }

  // 删除播放列表
  Future<void> deletePlaylist(int id) async {
    await _playlistBox.delete(id); // 删除指定ID的播放列表
  }
}
