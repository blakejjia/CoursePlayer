import 'dart:typed_data';

import 'package:course_player/data/repositories/covers_repository.dart';
import 'package:course_player/data/repositories/playlist_repository.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/repositories/song_repository.dart';
import 'package:course_player/logic/blocs/settings/settings_cubit.dart';
import 'package:course_player/main.dart';

class LoadFromDb {
  SongRepository songDAO = getIt<SongRepository>();

  Future<List<Song>> getAllSongs() async => songDAO.getAllSongs();

  Future<List<Playlist>> getAllPlaylists() async {
    return getIt<PlaylistRepository>().getAllPlaylists();
  }

  Future<List<Song>> getSongsByPlaylist(Playlist playlist) async {
    List<Song> songs = await songDAO.getSongByPlaylist(playlist.title);
    return _handleSongs(songs);
  }

  Future<List<Song>?> getSongsByPlaylistId(int id) async {
    if (id == 0) return null;
    Playlist? playlist = await getPlaylistById(id);
    List<Song> songs = await songDAO.getSongByPlaylist(playlist!.title);
    return _handleSongs(songs);
  }

  Future<Uint8List?> getCoverUint8ListByPlaylist(Playlist playlist) async {
    if (!getIt<SettingsCubit>().state.showCover) {
      Cover? defaultCover = await getIt<CoversRepository>().getCoverById(0);
      return defaultCover?.cover;
    }
    Cover? cover =
        await getIt<CoversRepository>().getCoverById(playlist.imageId);
    return cover?.cover;
  }

  Future<Playlist?> getPlaylistByName(String playlist) async {
    return getIt<PlaylistRepository>().getPlaylistByName(playlist);
  }

  Future<Playlist?> getPlaylistById(int id) async {
    return getIt<PlaylistRepository>().getPlaylistById(id);
  }
}

/// this is the sort function for playlist
List<Song> _handleSongs(List<Song> songs) {
  _sortSongsByTitle(songs);
  if (getIt<SettingsCubit>().state.cleanFileName) {
    List<Song> cleanedSongList = _cleanSongTitles(songs);
    return cleanedSongList;
  }
  return songs;
}

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

/// here, we clean song titles
List<Song> _cleanSongTitles(List<Song> songs) {
  List<Song> cleanedSongs = List.from(songs);

  String commonSubstring = _findCommonSubstring(songs);

  // Step 2: 清理每个歌曲的title
  return cleanedSongs.map((song) {
    String cleanedTitle = song.title;

    // 去掉检测到的通用字符串
    if (commonSubstring.isNotEmpty) {
      // 去掉开头的通用字符串
      if (cleanedTitle.startsWith(commonSubstring)) {
        cleanedTitle = cleanedTitle.substring(commonSubstring.length).trim();
      }
      // 去掉结尾的通用字符串
      if (cleanedTitle.endsWith(commonSubstring)) {
        cleanedTitle = cleanedTitle
            .substring(0, cleanedTitle.length - commonSubstring.length)
            .trim();
      }
    }

    // 去掉所有 "&" 字符
    cleanedTitle = cleanedTitle.replaceAll('&', '');

    // 返回一个新的 Song 实例，保持其他属性不变
    return Song(
      id: song.id,
      artist: song.artist,
      title: cleanedTitle,
      playlist: song.playlist,
      length: song.length,
      imageId: song.imageId,
      path: song.path,
    );
  }).toList();
}

String _findCommonSubstring(List<Song> songs) {
  Map<String, int> substringCount = {};

  for (var song in songs) {
    // 提取开头和结尾的非数字字符
    final pattern = RegExp(r'^[a-zA-Z]+|[a-zA-Z]+$');
    final matches = pattern.allMatches(song.title);

    for (var match in matches) {
      String substring = match.group(0)!;
      substringCount[substring] = (substringCount[substring] ?? 0) + 1;
    }
  }

  // 找出出现频率超过70%的字符串
  int threshold = (songs.length * 0.7).ceil();
  for (var entry in substringCount.entries) {
    if (entry.value >= threshold) {
      return entry.key;
    }
  }
  return '';
}
