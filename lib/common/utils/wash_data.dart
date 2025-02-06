// TODO 1: algorithms here weather applied depends on settings bloc

import '../data/models/models.dart';

/// [washArtist] was applied when loading data from file
/// this function is used to clean up the artist name
String washArtist(String? artist) {
  if (artist == null) {
    return 'Unknown Artist';
  } else if (artist.length > 20) {
    return '${artist.substring(0, 20)}...';
  }
  return artist;
}

/// [getAlbumArtistBySet] was applied when loading data from file
/// this function is used to format the author of the playlist
String getAlbumArtistBySet(Set<String> artists) {
  if(artists.isEmpty) {
    return 'Unknown Artist';
  } else if (artists.length < 3) {
    return artists.map((artist) => washArtist(artist)).toSet().join(' ');
  } else {
    return "Various Artists";
  }
}

/// [sortSongsByTitle] was applied when loading data from file
/// this function is used to sort the songs by title
/// TODO: ignore artist depends on user selection
void sortSongsByTitle(List<Song> songs) {
  songs.sort((a, b) {
    int artistComparison = a.artist.compareTo(b.artist);
    if (artistComparison != 0) {
      return artistComparison;
    }

    bool aContainsPreface = a.title.contains("发刊") || a.title.contains("欢迎词");
    bool bContainsPreface = b.title.contains("发刊") || b.title.contains("欢迎词");

    if (aContainsPreface && !bContainsPreface) {
      return -1;
    }
    if (bContainsPreface && !aContainsPreface) {
      return 1;
    }

    // find number in title, reasonable sort for numbers
    int? extractNumber(String title) {
      RegExp regExp = RegExp(r'\d+');
      Match? match = regExp.firstMatch(title);
      return match != null ? int.parse(match.group(0)!) : null;
    }

    int? aNumber = extractNumber(a.title);
    int? bNumber = extractNumber(b.title);

    if (aNumber != null && bNumber != null) {
      return aNumber.compareTo(bNumber);
    }

    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
  });
}

/// [cleanSongTitles] was applied when loading data from file
/// this function is used to clean up the song title
/// optional depends on user settings
List<Song> cleanSongTitles(List<Song> songs) {
  List<Song> cleanedSongs = List.from(songs);

  String commonSubstring = findCommonSubstring(songs);

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
      album: song.album,
      parts: song.parts,
      length: song.length,
      imageId: song.imageId,
      path: song.path,
      playedInSecond: song.playedInSecond,
    );
  }).toList();
}

String findCommonSubstring(List<Song> songs) {
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
