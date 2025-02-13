
import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/repositories/song_repository.dart';
import 'package:lemon/main.dart';

import '../../../settingsPage/bloc/settings_cubit.dart';
import '../../utils/wash_data.dart';
import '../repositories/album_repository.dart';

class LoadFromDb {
  SongRepository songDAO = getIt<SongRepository>();

  Future<List<Song>> getAllSongs() async => songDAO.getAllSongs();

  Future<List<Song>?> getSongsByPlaylist(Album playlist) async {
    List<Song>? songs = await songDAO.getSongsByAlbumId(playlist.id);
    return _handleSongs(songs!);
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
