import 'package:lemon/core/data/models/models.dart';

/// [sortSongs] was applied when loading data from file
/// this function is used to sort the songs by title
/// sort definition:
///  1. sort by parts, same parts should be together
///  2. sort by number in the title
///  3. sort by title
/// 1 > 2 > 3
void sortSongs(List<Song> songs) async {
  // Sort songs based on the defined criteria
  List<String> specialTitle = ["发刊词", "欢迎词"];
  songs.sort((a, b) {
    if (specialTitle.contains(a.title)) {
      return -1;
    } else if (specialTitle.contains(b.title)) {
      return 1;
    }

    if (a.disc != null && b.disc != null) {
      int partsComparison = a.disc!.compareTo(b.disc!);
      if (partsComparison != 0) return partsComparison;
    }

    int? aNumber = extractNumber(a.title);
    int? bNumber = extractNumber(b.title);
    if (aNumber != null && bNumber != null) {
      return aNumber.compareTo(bNumber);
    }

    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
  });

  for (int i = 0; i < songs.length; i++) {
    songs[i] = songs[i].copyWith(track: i + 1);
  }
}

int? extractNumber(String title) {
  RegExp regExp = RegExp(r'\d+');
  Match? match = regExp.firstMatch(title);
  return match != null ? int.parse(match.group(0)!) : null;
}

/// [cleanSong] was applied when loading data from file
/// this function is used to clean up the song title
/// optional depends on user settings
List<Song> cleanSong(List<Song> songs) {
  // init
  List<Song> cleanedSongs = List.from(songs);

  // 1. Clean title ===============
  String commonSubstring = _findCommonSubstring(songs);
  return cleanedSongs.map((song) {
    String cleanedTitle = song.title;

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
    cleanedTitle = cleanedTitle.replaceAll('&', '');

    // 2. clean artist
    String cleanedArtist = _washArtist(song.artist);

    // 返回一个新的 Song 实例，保持其他属性不变
    return song.copyWith(title: cleanedTitle, artist: cleanedArtist);
  }).toList();
}

// helper functions =======================
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
  int threshold = (songs.length * 0.4).ceil();
  for (var entry in substringCount.entries) {
    if (entry.value >= threshold) {
      return entry.key;
    }
  }
  return '';
}

String _washArtist(String artist) {
  if (artist.length > 10) return "";
  String cleaned = artist.replaceAll(RegExp(r'[&/\\]'), ' ');
  cleaned = cleaned.trim();
  return cleaned;
}
