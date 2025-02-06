import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:lemon/common/data/models/models.dart';
import 'package:lemon/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

import '../../../common/data/providers/load_from_db.dart';

part 'song_list_page_event.dart';
part 'song_lists_page_state.dart';

class SongListPageBloc extends Bloc<SongListPageEvent, SongListPageState> {
  SongListPageBloc() : super(AlbumPageLoading()) {
    on<AudioInfoLocatePlaylist>(_onLocatePlaylist);
  }

  Future<void> _onLocatePlaylist(event, emit) async {
    emit(AlbumPageLoading());
    List<Song> songList =
        await getIt<LoadFromDb>().getSongsByPlaylist(event.album);
    Uint8List? picture =
        await getIt<LoadFromDb>().getCoverUint8ListByPlaylist(event.album);
    emit(AlbumPageReady(
        playlist: event.album, buffer: songList, picture: picture));
  }
}
