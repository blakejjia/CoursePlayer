import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:course_player/data/models/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'audio_info_event.dart';
part 'audio_info_state.dart';

class AudioInfoBloc extends Bloc<AudioInfoEvent, AudioInfoState> {
  AudioInfoBloc() : super(const AudioInfoIdle()) {
    on<LocateSong>(_onLocateSong);
    on<AudioInfoNextSong>((event, emit) {
      emit(AudioInfoReady(
          state.index + 1, state.playlist, state.buffer, state.image));
    });
  }

  FutureOr<void> _onLocateSong(event, emit) async {
    emit(AudioInfoReady(
        event.index, event.playlist, event.songList, event.image));
  }
}
