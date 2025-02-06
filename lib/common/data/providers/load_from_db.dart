import 'dart:typed_data';

import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/repositories/song_repository.dart';
import 'package:lemon/main.dart';

import '../../../settingsPage/bloc/settings_cubit.dart';
import '../../utils/wash_data.dart';
import '../repositories/covers_repository.dart';
import '../repositories/album_repository.dart';

class LoadFromDb {
  SongRepository songDAO = getIt<SongRepository>();

  Future<List<Song>> getAllSongs() async => songDAO.getAllSongs();

  Future<List<Album>> getAllPlaylists() async {
    return getIt<AlbumRepository>().getAllAlbums();
  }

  Future<List<Song>> getSongsByPlaylist(Album playlist) async {
    List<Song> songs = await songDAO.getSongByPlaylist(playlist.title);
    return _handleSongs(songs);
  }

  Future<List<Song>?> getSongsByPlaylistId(int id) async {
    if (id == 0) return null;
    Album? playlist = await getPlaylistById(id);
    List<Song> songs = await songDAO.getSongByPlaylist(playlist!.title);
    return _handleSongs(songs);
  }

  Future<Uint8List?> getCoverUint8ListByPlaylist(Album playlist) async {
    if (!getIt<SettingsCubit>().state.showCover) {
      Cover? defaultCover = await getIt<CoversRepository>().getCoverById(0);
      return defaultCover?.cover;
    }
    Cover? cover =
        await getIt<CoversRepository>().getCoverById(playlist.imageId);
    return cover?.cover;
  }

  Future<Album?> getPlaylistByName(String playlist) async {
    return getIt<AlbumRepository>().getAlbumByName(playlist);
  }

  Future<Album?> getPlaylistById(int id) async {
    return getIt<AlbumRepository>().getAlbumById(id);
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
