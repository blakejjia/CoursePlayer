import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/providers/load_from_db.dart';
import 'package:course_player/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'audio_info_event.dart';
part 'audio_info_state.dart';

class AudioInfoBloc extends Bloc<AudioInfoEvent, AudioInfoState> {
  AudioInfoBloc() : super(const AudioInfoIdle()) {
    on<LocateSong>(_onLocateSong);
  }

  FutureOr<void> _onLocateSong(event, emit) async {
    //! 设定播放列表顺序 and everything
    Playlist? playlist =
        await getIt<LoadFromDb>().getPlaylistByName(event.song.playlist);
    List<Song?> buffer = playlist!=null? await getIt<LoadFromDb>().getSongsByPlaylist(playlist) : [];

    Uint8List? image = playlist!=null? await getIt<LoadFromDb>().getCoverUint8ListByPlaylist(playlist) : null;
    emit(AudioInfoReady(event.index, playlist, buffer, image));
  }
}
