import 'dart:io';

import 'package:audiotags/audiotags.dart';

/// This function writes the artist tag to the song.
/// Other tags are copied as is.
Future<void> writeArtistTag(String baseFolderPath, String artist,
    {String? subfolderName}) async {
  final directory = Directory(subfolderName != null
      ? '$baseFolderPath/$subfolderName'
      : baseFolderPath);
  final files = directory.listSync(recursive: true);

  for (var file in files) {
    try {
      final Tag? tag = await AudioTags.read(file.path);
      if (tag == null) {
        continue;
      }
      final newTag = tag.copyWith(albumArtist: artist);
      // TODO: 定向rebuild database
      await AudioTags.write(file.path, newTag);
    } catch (e) {
      print('Error writing tag to file: $e');
    }
  }
}

extension on Tag {
  Tag copyWith({
    String? title,
    String? trackArtist,
    String? album,
    String? albumArtist,
    int? year,
    String? genre,
    int? trackNumber,
    int? trackTotal,
    int? discNumber,
    int? discTotal,
    int? duration,
    List<Picture>? pictures,
  }) {
    return Tag(
      title: title ?? this.title,
      trackArtist: trackArtist ?? this.trackArtist,
      album: album ?? this.album,
      albumArtist: albumArtist ?? this.albumArtist,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      trackNumber: trackNumber ?? this.trackNumber,
      trackTotal: trackTotal ?? this.trackTotal,
      discNumber: discNumber ?? this.discNumber,
      discTotal: discTotal ?? this.discTotal,
      duration: duration ?? this.duration,
      pictures: pictures ?? this.pictures,
    );
  }
}
