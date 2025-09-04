import 'dart:convert';

/// Schema root for MediaLibrary.json
class MediaLibraryFileRoot {
  final int schemaVersion; // JSON schema version, independent from Drift
  final String generatedAt; // ISO8601
  final List<Album> albums;
  final List<Song> songs;

  const MediaLibraryFileRoot({
    required this.schemaVersion,
    required this.generatedAt,
    required this.albums,
    required this.songs,
  });

  MediaLibraryFileRoot copyWith({
    int? schemaVersion,
    String? generatedAt,
    List<Album>? albums,
    List<Song>? songs,
  }) =>
      MediaLibraryFileRoot(
        schemaVersion: schemaVersion ?? this.schemaVersion,
        generatedAt: generatedAt ?? this.generatedAt,
        albums: albums ?? this.albums,
        songs: songs ?? this.songs,
      );

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'generatedAt': generatedAt,
        'albums': albums.map((e) => e.toJson()).toList(),
        'songs': songs.map((e) => e.toJson()).toList(),
      };

  static MediaLibraryFileRoot fromJson(Map<String, dynamic> json) =>
      MediaLibraryFileRoot(
        schemaVersion: json['schemaVersion'] as int? ?? 1,
        generatedAt:
            json['generatedAt'] as String? ?? DateTime.now().toIso8601String(),
        albums: ((json['albums'] as List?) ?? const [])
            .map((e) => Album.fromJson(e as Map<String, dynamic>))
            .toList()
            .cast<Album>(),
        songs: ((json['songs'] as List?) ?? const [])
            .map((e) => Song.fromJson(e as Map<String, dynamic>))
            .toList()
            .cast<Song>(),
      );

  static MediaLibraryFileRoot empty() => MediaLibraryFileRoot(
        schemaVersion: 1,
        generatedAt: DateTime.now().toIso8601String(),
        albums: const [],
        songs: const [],
      );

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());
  static MediaLibraryFileRoot decode(String source) =>
      fromJson(jsonDecode(source) as Map<String, dynamic>);
}

class Album {
  // basic information
  final int id;
  final String title;
  final String author;
  final String sourcePath;
  final int totalTracks;
  final List<Song>? songs;

// user history
  final int? lastPlayedTime;
  final int? lastPlayedIndex;
  final int? playedTracks;

  // business logic field
  final String? regexPattern;

  const Album({
    required this.id,
    required this.title,
    required this.author,
    required this.sourcePath,
    this.lastPlayedTime,
    this.lastPlayedIndex,
    required this.totalTracks,
    this.playedTracks,
    this.songs,
    this.regexPattern,
  });

  Album copyWith({
    int? id,
    String? title,
    String? author,
    String? sourcePath,
    int? lastPlayedTime,
    int? lastPlayedIndex,
    int? totalTracks,
    int? playedTracks,
    List<Song>? songs,
    String? regexPattern,
  }) =>
      Album(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        sourcePath: sourcePath ?? this.sourcePath,
        lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
        lastPlayedIndex: lastPlayedIndex ?? this.lastPlayedIndex,
        totalTracks: totalTracks ?? this.totalTracks,
        playedTracks: playedTracks ?? this.playedTracks,
        songs: songs ?? this.songs,
        regexPattern: regexPattern ?? this.regexPattern,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'sourcePath': sourcePath,
        'lastPlayedTime': lastPlayedTime,
        'lastPlayedIndex': lastPlayedIndex,
        'totalTracks': totalTracks,
        'playedTracks': playedTracks,
        'songs': songs?.map((e) => e.toJson()).toList(),
        'regexPattern': regexPattern,
      };

  static Album fromJson(Map<String, dynamic> json) => Album(
        id: json['id'] as int,
        title: json['title'] as String,
        author: json['author'] as String,
        sourcePath: json['sourcePath'] as String,
        // these fields were nullable in the model but previously cast as non-null
        // causing decode to throw when keys were missing/null. Use nullable casts
        // and sensible defaults where appropriate.
        lastPlayedTime: json['lastPlayedTime'] as int?,
        lastPlayedIndex: json['lastPlayedIndex'] as int?,
        totalTracks: json['totalTracks'] as int? ?? 0,
        playedTracks: json['playedTracks'] as int? ?? 0,
        songs: ((json['songs'] as List?) ?? const [])
            .map((e) => Song.fromJson(e as Map<String, dynamic>))
            .toList()
            .cast<Song>(),
        regexPattern: json['regexPattern'] as String?,
      );
}

class Song {
  // basic fields
  final int id;
  final String artist;
  final String title;
  final int length;
  final String path;

  // user fields
  final int? track;
  final String? disc; // disc name
  final String? alias; // alias name

  // play history
  final int? playedInSecond;
  final DateTime? lastPlayed;
  final DateTime? addedAt;

  const Song({
    required this.id,
    required this.artist,
    required this.title,
    required this.length,
    this.disc,
    required this.path,
    this.track,
    this.alias,
    this.playedInSecond,
    this.lastPlayed,
    this.addedAt,
  });

  Song copyWith({
    int? id,
    String? artist,
    String? title,
    int? length,
    String? disc,
    String? path,
    int? track,
    String? alias,
    int? playedInSecond,
    DateTime? lastPlayed,
    DateTime? addedAt,
  }) =>
      Song(
        id: id ?? this.id,
        artist: artist ?? this.artist,
        title: title ?? this.title,
        length: length ?? this.length,
        disc: disc ?? this.disc,
        path: path ?? this.path,
        track: track ?? this.track,
        alias: alias ?? this.alias,
        playedInSecond: playedInSecond ?? this.playedInSecond,
        lastPlayed: lastPlayed ?? this.lastPlayed,
        addedAt: addedAt ?? this.addedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'artist': artist,
        'title': title,
        'length': length,
        'disc': disc,
        'path': path,
        'track': track,
        'alias': alias,
        'playedInSecond': playedInSecond,
        'lastPlayed': lastPlayed?.toIso8601String(),
        'addedAt': addedAt?.toIso8601String(),
      };

  static Song fromJson(Map<String, dynamic> json) => Song(
        id: json['id'] as int,
        artist: json['artist'] as String,
        title: json['title'] as String,
        length: json['length'] as int,
        disc: json['disc'] as String? ?? json['parts'] as String? ?? '',
        path: json['path'] as String,
        track: json['track'] as int?,
        alias: json['alias'] as String?,
        playedInSecond: json['playedInSecond'] as int?,
        lastPlayed: json['lastPlayed'] != null
            ? DateTime.parse(json['lastPlayed'] as String)
            : null,
        addedAt: json['addedAt'] != null
            ? DateTime.parse(json['addedAt'] as String)
            : null,
      );
}

// Covers are not stored persistently.
