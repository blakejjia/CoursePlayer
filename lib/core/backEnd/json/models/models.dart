class Song {
  final int id;
  final String artist;
  final String title;
  final int length;
  final int imageId; // always 0 in JSON backend
  final int album;
  final String parts;
  final int? track;
  final String path;
  final int playedInSecond;

  const Song({
    required this.id,
    required this.artist,
    required this.title,
    required this.length,
    required this.imageId,
    required this.album,
    required this.parts,
    required this.track,
    required this.path,
    required this.playedInSecond,
  });

  Song copyWith({
    int? id,
    String? artist,
    String? title,
    int? length,
    int? imageId,
    int? album,
    String? parts,
    int? track,
    String? path,
    int? playedInSecond,
  }) {
    return Song(
      id: id ?? this.id,
      artist: artist ?? this.artist,
      title: title ?? this.title,
      length: length ?? this.length,
      imageId: imageId ?? this.imageId,
      album: album ?? this.album,
      parts: parts ?? this.parts,
      track: track ?? this.track,
      path: path ?? this.path,
      playedInSecond: playedInSecond ?? this.playedInSecond,
    );
  }
}

class Album {
  final int id;
  final String title;
  final String author;
  final int imageId; // always 0 in JSON backend
  final String sourcePath;
  final int lastPlayedTime;
  final int lastPlayedIndex;
  final int totalTracks;
  final int playedTracks;

  const Album({
    required this.id,
    required this.title,
    required this.author,
    required this.imageId,
    required this.sourcePath,
    required this.lastPlayedTime,
    required this.lastPlayedIndex,
    required this.totalTracks,
    required this.playedTracks,
  });

  Album copyWith({
    int? id,
    String? title,
    String? author,
    int? imageId,
    String? sourcePath,
    int? lastPlayedTime,
    int? lastPlayedIndex,
    int? totalTracks,
    int? playedTracks,
  }) {
    return Album(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageId: imageId ?? this.imageId,
      sourcePath: sourcePath ?? this.sourcePath,
      lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
      lastPlayedIndex: lastPlayedIndex ?? this.lastPlayedIndex,
      totalTracks: totalTracks ?? this.totalTracks,
      playedTracks: playedTracks ?? this.playedTracks,
    );
  }
}

// Minimal Cover to satisfy legacy types; not used for persistence in JSON backend
class Cover {
  final int id;
  final List<int> cover; // bytes
  final String hash;

  const Cover({required this.id, required this.cover, required this.hash});
}
