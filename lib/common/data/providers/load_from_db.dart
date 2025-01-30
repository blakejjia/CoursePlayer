import 'dart:typed_data';

import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/repositories/song_repository.dart';
import 'package:lemon/main.dart';

import '../../../settingsPage/bloc/settings_cubit.dart';
import '../../utils/wash_data.dart';
import '../repositories/covers_repository.dart';
import '../repositories/playlist_repository.dart';

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
  sortSongsByTitle(songs);
  if (getIt<SettingsCubit>().state.cleanFileName) {
    List<Song> cleanedSongList = cleanSongTitles(songs);
    return cleanedSongList;
  }
  return songs;
}
