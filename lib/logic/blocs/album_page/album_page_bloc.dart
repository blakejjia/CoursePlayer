import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/providers/load_from_db.dart';

part 'album_page_event.dart';
part 'album_page_state.dart';

class AlbumPageBloc extends Bloc<AlbumPageEvent, AlbumPageState> {
  AlbumPageBloc() : super(const AlbumPageState()) {
    on<AudioInfoLocatePlaylist>(_onLocatePlaylist);
  }

  FutureOr<void> _onLocatePlaylist(event, emit) async {
    List<Song> songList =
        await getIt<LoadFromDb>().getSongsByPlaylist(event.playlist);
    Uint8List picture =
        await getIt<LoadFromDb>().getCoverUint8ListByPlaylist(event.playlist);
    List<Song> sortedSongList = sortSongsByTitle(songList);
    List<Song> cleanedSongList = cleanSongTitles(sortedSongList);

    emit(AlbumPageState(
        playlist: event.playlist, buffer: cleanedSongList, picture: picture));
  }
}

/// this is the sort function for playlist
List<Song> sortSongsByTitle(List<Song> songs) {
  // 创建一个拷贝的列表，避免修改原数据
  List<Song> sortedSongs = List.from(songs);

  sortedSongs.sort((a, b) {
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

  return sortedSongs;
}

/// here, we clean song titles
List<Song> cleanSongTitles(List<Song> songs) {
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
