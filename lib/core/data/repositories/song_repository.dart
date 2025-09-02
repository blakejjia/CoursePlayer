import 'package:lemon/core/data/utils/media_library_store.dart';
import 'package:lemon/core/data/models/media_library_schema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../wash_data.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';

class SongRepository {
  final MediaLibraryStore store;
  final Ref? ref;
  SongRepository(this.store, {this.ref});

  // 创建新歌曲
  Future<int> insertSong({
    required String artist,
    required String title,
    required int albumId,
    required int length,
    required String path,
    String? parts,
    required int playedInSecond,
  }) async {
    final root = await store.load();
    final nextId = (root.songs.isEmpty)
        ? 1
        : (root.songs.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);
    final dto = Song(
      id: nextId,
      artist: artist,
      title: title,
      length: length,
      path: path,
      disc: parts ?? '',
      track: null,
      playedInSecond: playedInSecond,
    );

    // Add to global songs list
    final updatedSongs = [...root.songs, dto];

    // Add to specific album's songs list
    final albumIndex = root.albums.indexWhere((a) => a.id == albumId);
    List<Album> updatedAlbums = [...root.albums];
    if (albumIndex >= 0) {
      final targetAlbum = root.albums[albumIndex];
      final albumSongs = targetAlbum.songs ?? [];
      updatedAlbums[albumIndex] = targetAlbum.copyWith(
        songs: [...albumSongs, dto],
      );
    }

    final next = root.copyWith(songs: updatedSongs, albums: updatedAlbums);
    await store.replace(next);
    return nextId;
  }

  // read
  Future<List<Song>> getAllSongs() async {
    final root = await store.load();
    final songs = <Song>[];

    // Collect songs from all albums
    for (final album in root.albums) {
      if (album.songs != null) {
        songs.addAll(album.songs!);
      }
    }

    return _handleSongs(songs);
  }

  Future<Song?> getSongById(int id) async {
    final root = await store.load();

    // Search through all albums to find the song
    for (final album in root.albums) {
      if (album.songs != null) {
        final song = album.songs!.where((e) => e.id == id).firstOrNull;
        if (song != null) {
          return song;
        }
      }
    }
    return null;
  }

  Future<List<Song>?> getSongsByAlbumId(int id) async {
    if (id == 0) return null;
    final root = await store.load();

    // Find the album and get its songs
    final album = root.albums.where((a) => a.id == id).firstOrNull;
    if (album?.songs == null) return null;

    final songs = album!.songs!;
    return _handleSongs(songs);
  }

  /// Core sorting + cleaning function
  List<Song> _handleSongs(List<Song> songs) {
    sortSongs(songs);
    // If ref is available, use it, otherwise use default settings
    if (ref != null) {
      final settings = ref!.read(settingsProvider);
      if (settings.cleanFileName) {
        return cleanSongTitles(songs);
      }
    }
    // Default behavior when no ref is available - don't clean filenames
    return songs;
  }

  // update
  Future<int> updateSongProgress(int id, int playedInSecond) async {
    final root = await store.load();

    // Update in global songs list
    final songIdx = root.songs.indexWhere((e) => e.id == id);
    if (songIdx < 0) return 0;

    final updatedSong =
        root.songs[songIdx].copyWith(playedInSecond: playedInSecond);
    final updatedSongs = [...root.songs];
    updatedSongs[songIdx] = updatedSong;

    // Update in album's songs list
    final updatedAlbums = <Album>[];
    for (final album in root.albums) {
      if (album.songs != null) {
        final albumSongIdx = album.songs!.indexWhere((s) => s.id == id);
        if (albumSongIdx >= 0) {
          final albumSongs = [...album.songs!];
          albumSongs[albumSongIdx] = updatedSong;
          updatedAlbums.add(album.copyWith(songs: albumSongs));
        } else {
          updatedAlbums.add(album);
        }
      } else {
        updatedAlbums.add(album);
      }
    }

    await store
        .replace(root.copyWith(songs: updatedSongs, albums: updatedAlbums));
    return 1;
  }

  Future<int> updateSongTrack(int id, int track) async {
    final root = await store.load();

    // Update in global songs list
    final songIdx = root.songs.indexWhere((e) => e.id == id);
    if (songIdx < 0) return 0;

    final updatedSong = root.songs[songIdx].copyWith(track: track);
    final updatedSongs = [...root.songs];
    updatedSongs[songIdx] = updatedSong;

    // Update in album's songs list
    final updatedAlbums = <Album>[];
    for (final album in root.albums) {
      if (album.songs != null) {
        final albumSongIdx = album.songs!.indexWhere((s) => s.id == id);
        if (albumSongIdx >= 0) {
          final albumSongs = [...album.songs!];
          albumSongs[albumSongIdx] = updatedSong;
          updatedAlbums.add(album.copyWith(songs: albumSongs));
        } else {
          updatedAlbums.add(album);
        }
      } else {
        updatedAlbums.add(album);
      }
    }

    await store
        .replace(root.copyWith(songs: updatedSongs, albums: updatedAlbums));
    return 1;
  }

  /// -------------- delete ----------------
  Future<int> deleteSong(int id) async {
    final root = await store.load();

    // Remove from global songs list
    final before = root.songs.length;
    final updatedSongs = root.songs.where((e) => e.id != id).toList();
    if (updatedSongs.length == before) return 0; // Song not found

    // Remove from album's songs list
    final updatedAlbums = <Album>[];
    for (final album in root.albums) {
      if (album.songs != null) {
        final albumSongs = album.songs!.where((s) => s.id != id).toList();
        updatedAlbums.add(album.copyWith(songs: albumSongs));
      } else {
        updatedAlbums.add(album);
      }
    }

    await store
        .replace(root.copyWith(songs: updatedSongs, albums: updatedAlbums));
    return 1;
  }

  Future<int> destroySongDb() async {
    final root = await store.load();
    await store.replace(root.copyWith(songs: const []));
    return 1;
  }

  Future<int> deleteSongsByAlbumId(int id) async {
    final root = await store.load();

    // Find the album and count its songs
    final albumIndex = root.albums.indexWhere((a) => a.id == id);
    if (albumIndex < 0) return 0;

    final album = root.albums[albumIndex];
    final songsCount = album.songs?.length ?? 0;
    if (songsCount == 0) return 0;

    // Get all song IDs from this album to remove from global songs list
    final songIds = album.songs!.map((s) => s.id).toSet();

    // Remove songs from global songs list
    final updatedSongs =
        root.songs.where((s) => !songIds.contains(s.id)).toList();

    // Clear the album's songs list
    final updatedAlbums = [...root.albums];
    updatedAlbums[albumIndex] = album.copyWith(songs: []);

    await store
        .replace(root.copyWith(songs: updatedSongs, albums: updatedAlbums));
    return songsCount;
  }
}
