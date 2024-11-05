import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/providers/load_from_db.dart';
import 'package:course_player/main.dart';
import 'package:meta/meta.dart';

part 'one_playlist_event.dart';
part 'one_playlist_state.dart';

class OnePlaylistBloc extends Bloc<OnePlaylistEvent, OnePlaylistState> {
  OnePlaylistBloc() : super(const OnePlaylistIdle(null, null, null)) {
    on<OnePlayListSelected>((event, emit) async {
      List<Song> songList =
          await getIt<LoadFromDb>().getSongsByPlaylist(event.playlist);
      //! sort below
      //! sort above
      Uint8List picture =
          await getIt<LoadFromDb>().getCoverUint8ListByPlaylist(event.playlist);
      emit(OnePlaylistIdle(event.playlist, songList, picture));
    });
    on<OnePlayListPlay>((event, emit) {
      emit(OnePlaylistInAudio(
          event.index, state.currentPlaylist, state.songList, state.picture));
    });
  }
}
