import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/repositories/song_repository.dart';
import 'package:lemon/main.dart';

import '../../../settingsPage/bloc/settings_cubit.dart';
import '../../utils/wash_data.dart';
import '../repositories/album_repository.dart';

class LoadFromDb {
  SongRepository songDAO = getIt<SongRepository>();

  Future<List<Song>> getAllSongs() async => songDAO.getAllSongs();

  Future<Album?> getPlaylistById(int id) async {
    return getIt<AlbumRepository>().getAlbumById(id);
  }
}


