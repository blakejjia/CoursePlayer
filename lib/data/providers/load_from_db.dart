import 'dart:typed_data';
import 'package:course_player/data/repositories/covers_repository.dart';
import 'package:course_player/data/repositories/playlist_repository.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/repositories/song_repository.dart';
import 'package:course_player/logic/blocs/settings/settings_cubit.dart';
import 'package:course_player/main.dart';

class LoadFromDb {
  SongRepository songRepository = getIt<SongRepository>();
  PlaylistRepository playlistRepository = getIt<PlaylistRepository>();
  CoversRepository coversRepository = getIt<CoversRepository>();
  SettingsCubit settingsCubit = getIt<SettingsCubit>();

  // 获取所有歌曲
  Future<List<Song>> getAllSongs() async {
    return songRepository.getAllSongs();
  }

  // 获取所有播放列表
  Future<List<Playlist>> getAllPlaylists() async {
    return playlistRepository.getAllPlaylists();
  }

  // 根据播放列表获取歌曲
  Future<List<Song>> getSongsByPlaylist(Playlist playlist) async {
    List<Song> songs = await songRepository.getSongByPlaylist(playlist.title);
    return _handleSongs(songs);
  }

  // 根据播放列表ID获取歌曲
  Future<List<Song>?> getSongsByPlaylistId(int playlistId) async {
    Playlist? playlist = await getPlaylistById(playlistId);
    if (playlist == null) return [];
    List<Song> songs = await songRepository.getSongByPlaylist(playlist.title);
    return _handleSongs(songs);
  }

  // 根据播放列表获取封面
  Future<Uint8List?> getCoverUint8ListByPlaylist(Playlist playlist) async {
    if (!settingsCubit.state.showCover) {
      Cover? defaultCover = await coversRepository.getCoverById(0);
      return defaultCover?.cover;
    }
    Cover? cover = await coversRepository.getCoverById(playlist.imageId);
    return cover?.cover;
  }

  // 根据名称获取播放列表
  Future<Playlist?> getPlaylistByName(String name) async {
    return playlistRepository.getPlaylistByName(name);
  }

  // 根据ID获取播放列表
  Future<Playlist?> getPlaylistById(int playlistId) async {  // 改为 String 类型
    return playlistRepository.getPlaylistById(playlistId);
  }
}

/// 这个是排序函数
List<Song> _handleSongs(List<Song> songs) {
  _sortSongsByTitle(songs);

  // 简化获取 SettingsCubit 的方式
  final settings = getIt<SettingsCubit>().state;

  if (settings.cleanFileName) {
    List<Song> cleanedSongList = _cleanSongTitles(songs);
    return cleanedSongList;
  }
  return songs;
}

// 根据标题排序歌曲
void _sortSongsByTitle(List<Song> songs) {
  songs.sort((a, b) {
    // 按照 artist 排序，确保相同 artist 的歌曲排在一起
    int artistComparison = a.artist.compareTo(b.artist);
    if (artistComparison != 0) {
      return artistComparison;
    }

    // 检查发刊词和欢迎词，优先排序包含这两个词的项
    bool aContainsPreface = a.title.contains("发刊") || a.title.contains("欢迎词");
    bool bContainsPreface = b.title.contains("发刊") || b.title.contains("欢迎词");

    if (aContainsPreface && !bContainsPreface) {
      return -1;
    }
    if (bContainsPreface && !aContainsPreface) {
      return 1;
    }

    // 最后按 title 自然顺序排序
    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
  });
}

/// 清理歌曲标题
List<Song> _cleanSongTitles(List<Song> songs) {
  // 不用多次调用 List.from，而是直接操作
  String commonSubstring = _findCommonSubstring(songs);

  return songs.map((song) {
    String cleanedTitle = song.title;

    // 去掉检测到的通用字符串
    if (commonSubstring.isNotEmpty) {
      if (cleanedTitle.startsWith(commonSubstring)) {
        cleanedTitle = cleanedTitle.substring(commonSubstring.length).trim();
      }
      if (cleanedTitle.endsWith(commonSubstring)) {
        cleanedTitle = cleanedTitle
            .substring(0, cleanedTitle.length - commonSubstring.length)
            .trim();
      }
    }

    // 去掉所有 "&" 字符
    cleanedTitle = cleanedTitle.replaceAll('&', '');

    // 返回一个新的 Song 实例，保持其他属性不变
    return Song((b) => b
      ..title = cleanedTitle
      ..artist = song.artist
      ..playlist = song.playlist  // 保持 playlistId 为 String 类型
      ..length = song.length
      ..imageId = song.imageId
      ..path = song.path);
  }).toList();
}

// 找出歌曲标题中最常见的子字符串
String _findCommonSubstring(List<Song> songs) {
  Map<String, int> substringCount = {};

  for (var song in songs) {
    final pattern = RegExp(r'^[a-zA-Z]+|[a-zA-Z]+$');
    final matches = pattern.allMatches(song.title);

    for (var match in matches) {
      String substring = match.group(0)!;
      substringCount[substring] = (substringCount[substring] ?? 0) + 1;
    }
  }

  int threshold = (songs.length * 0.7).ceil();
  for (var entry in substringCount.entries) {
    if (entry.value >= threshold) {
      return entry.key;
    }
  }
  return '';
}
