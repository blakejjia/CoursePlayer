import 'dart:typed_data';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lemon/core/backEnd/json/models.dart' show Album, Cover, Song;
import 'package:lemon/main.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';

/// Covers are loaded dynamically from mp3 tags; repository fetches on demand.
class CoversRepository {
  CoversRepository();

  Future<int> createCover(Uint8List coverData, String hash) async => 0;

  Future<int> createCoverWithId(
          int id, Uint8List coverData, String hash) async =>
      0;

  Future<Cover?> getCoverById(int id) async => null;

  Future<Uint8List?> getCoverUint8ListByPlaylist(Album playlist) async {
    final settings = providerContainer.read(settingsProvider);
    // Return default cover if user disabled covers.
    if (!settings.showCover) {
      return _defaultCover();
    }

    // Try to find a song in this album and read its embedded picture.
    final songs = await providerContainer
        .read(songRepositoryProvider)
        .getSongsByAlbumId(playlist.id);
    if (songs == null || songs.isEmpty) {
      return _defaultCover();
    }

    // Prefer the lastPlayedIndex if valid, otherwise first song.
    Song? candidate;
    if (playlist.lastPlayedIndex >= 0) {
      candidate = songs.firstWhere(
        (s) => s.id == playlist.lastPlayedIndex,
        orElse: () => songs.first,
      );
    } else {
      candidate = songs.first;
    }

    try {
      final tag = await AudioTags.read(candidate.path);
      final pics = tag?.pictures;
      if (pics != null && pics.isNotEmpty) {
        return pics.first.bytes;
      }
    } catch (_) {
      // ignore and fallback
    }
    return _defaultCover();
  }

  Future<Uint8List> _defaultCover() async {
    final data = await rootBundle.load('assets/default_cover.jpeg');
    return data.buffer.asUint8List();
  }

  Future<int?> getCoverIdByHash(String hash) async => null;

  Future<bool> updateCover(
          int id, Uint8List newCoverData, String newHash) async =>
      false;

  Future<int> deleteCover(int id) async => 0;

  Future<List<Cover>> getAllCovers() async => <Cover>[];

  Future<int> destroyCoversDb() async => 1;
}
