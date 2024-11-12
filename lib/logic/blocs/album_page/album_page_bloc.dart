import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/providers/load_from_db.dart';

part 'album_page_event.dart';
part 'album_page_state.dart';

class AlbumPageBloc extends Bloc<AlbumPageEvent, AlbumPageState> {
  AlbumPageBloc()
      : super(const AlbumPageState(
            playlist: Playlist(
                id: 0, title: "unknown", author: "unknown", imageId: 0))) {
    on<AudioInfoLocatePlaylist>(_onLocatePlaylist);
  }

  FutureOr<void> _onLocatePlaylist(event, emit) async {
    List<Song> songList =
        await getIt<LoadFromDb>().getSongsByPlaylist(event.playlist);
    Uint8List? picture =
        await getIt<LoadFromDb>().getCoverUint8ListByPlaylist(event.playlist);
    emit(AlbumPageState(
        playlist: event.playlist, buffer: songList, picture: picture));
  }
}
