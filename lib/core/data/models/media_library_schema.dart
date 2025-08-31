import 'dart:convert';

/// Schema root for MediaLibrary.json
class MediaLibraryFileRoot {
  final int schemaVersion; // JSON schema version, independent from Drift
  final String generatedAt; // ISO8601
  final List<AlbumDto> albums;
  final List<SongDto> songs;

  const MediaLibraryFileRoot({
    required this.schemaVersion,
    required this.generatedAt,
    required this.albums,
    required this.songs,
  });

  MediaLibraryFileRoot copyWith({
    int? schemaVersion,
    String? generatedAt,
    List<AlbumDto>? albums,
    List<SongDto>? songs,
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
            .map((e) => AlbumDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        songs: ((json['songs'] as List?) ?? const [])
            .map((e) => SongDto.fromJson(e as Map<String, dynamic>))
            .toList(),
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

class AlbumDto {
  final int id;
  final String title;
  final String author;
  final String sourcePath;
  final int lastPlayedTime;
  final int lastPlayedIndex;
  final int totalTracks;
  final int playedTracks;

  const AlbumDto({
    required this.id,
    required this.title,
    required this.author,
    required this.sourcePath,
    required this.lastPlayedTime,
    required this.lastPlayedIndex,
    required this.totalTracks,
    required this.playedTracks,
  });

  AlbumDto copyWith({
    int? id,
    String? title,
    String? author,
    String? sourcePath,
    int? lastPlayedTime,
    int? lastPlayedIndex,
    int? totalTracks,
    int? playedTracks,
  }) =>
      AlbumDto(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        sourcePath: sourcePath ?? this.sourcePath,
        lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
        lastPlayedIndex: lastPlayedIndex ?? this.lastPlayedIndex,
        totalTracks: totalTracks ?? this.totalTracks,
        playedTracks: playedTracks ?? this.playedTracks,
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
      };

  static AlbumDto fromJson(Map<String, dynamic> json) => AlbumDto(
        id: json['id'] as int,
        title: json['title'] as String,
        author: json['author'] as String,
        sourcePath: json['sourcePath'] as String,
        lastPlayedTime: json['lastPlayedTime'] as int,
        lastPlayedIndex: json['lastPlayedIndex'] as int,
        totalTracks: json['totalTracks'] as int,
        playedTracks: json['playedTracks'] as int,
      );
}

class SongDto {
  final int id;
  final String artist;
  final String title;
  final int length;
  final int album; // references AlbumDto.id
  final String parts;
  final int? track;
  final String path;
  final int playedInSecond;

  const SongDto({
    required this.id,
    required this.artist,
    required this.title,
    required this.length,
    required this.album,
    required this.parts,
    required this.track,
    required this.path,
    required this.playedInSecond,
  });

  SongDto copyWith({
    int? id,
    String? artist,
    String? title,
    int? length,
    int? album,
    String? parts,
    int? track,
    String? path,
    int? playedInSecond,
  }) =>
      SongDto(
        id: id ?? this.id,
        artist: artist ?? this.artist,
        title: title ?? this.title,
        length: length ?? this.length,
        album: album ?? this.album,
        parts: parts ?? this.parts,
        track: track ?? this.track,
        path: path ?? this.path,
        playedInSecond: playedInSecond ?? this.playedInSecond,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'artist': artist,
        'title': title,
        'length': length,
        'album': album,
        'parts': parts,
        'track': track,
        'path': path,
        'playedInSecond': playedInSecond,
      };

  static SongDto fromJson(Map<String, dynamic> json) => SongDto(
        id: json['id'] as int,
        artist: json['artist'] as String,
        title: json['title'] as String,
        length: json['length'] as int,
        album: json['album'] as int,
        parts: json['parts'] as String? ?? '',
        track: json['track'] as int?,
        path: json['path'] as String,
        playedInSecond: json['playedInSecond'] as int,
      );
}

// Covers are not stored persistently.
