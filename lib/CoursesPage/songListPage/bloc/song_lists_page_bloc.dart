import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/common/data/repositories/album_repository.dart';
import 'package:lemon/common/data/repositories/covers_repository.dart';
import 'package:lemon/common/data/repositories/song_repository.dart';
import 'package:lemon/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'song_list_page_event.dart';
part 'song_lists_page_state.dart';

class SongListPageBloc extends Bloc<SongListPageEvent, SongListPageState> {
  SongListPageBloc() : super(SongListPageLoading()) {
    on<SongListLocateAlbum>(_onLocateAlbum);
    on<UpdateSongListEvent>(_onUpdateSongList);
  }

  Future<void> _onLocateAlbum(event, emit) async {
    emit(SongListPageLoading());
    List<Song>? songList =
        await getIt<SongRepository>().getSongsByAlbumId(event.album.id);
    Uint8List? picture =
        await getIt<CoversRepository>().getCoverUint8ListByPlaylist(event.album);
    emit(SongListPageReady(
        album: event.album, buffer: songList, picture: picture));
  }

  Future<void> _onUpdateSongList(event, emit) async {
    if (state is SongListPageReady) {
      List<Song>? songList = await getIt<SongRepository>().getSongsByAlbumId((state as SongListPageReady).album.id);
      Album? album = await getIt<AlbumRepository>().getAlbumById((state as SongListPageReady).album.id);
      emit((state as SongListPageReady).copyWith(buffer: songList, album: album));
    }
  }

}

