import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

import '../../../data/providers/load_from_db.dart';

part 'audio_info_event.dart';
part 'audio_info_state.dart';

class AudioInfoBloc extends Bloc<AudioInfoEvent, AudioInfoState> {
  final AudioPlayer _audioPlayer;
  late StreamSubscription streamSubscription;

  AudioInfoBloc(this._audioPlayer) : super(const AudioInfoIdle()) {
    initBloc();
    on<AudioInfoLocatePlaylist>(_onLocatePlaylist);
    on<AudioInfoLocateSong>(_onLocateSong);
    on<_AudioInfoUpdateIndex>(_onUpdateIndex);
  }

  FutureOr<void> _onUpdateIndex(event, emit) {
    if (state is AudioInfoSong) {
      final songState = state as AudioInfoSong;
      // 使用 copyWith 来更新 index
      emit(songState.copyWith(index: event.index));
    }
  }

  void initBloc() {
    streamSubscription = _audioPlayer.playbackEventStream
        .map((playBackEvent) => playBackEvent.currentIndex) // 只提取 currentIndex
        .distinct() // 仅当 currentIndex 变化时才发出事件
        .listen((currentIndex) {
      if (currentIndex != null) {
        add(_AudioInfoUpdateIndex(currentIndex));
      }
    });
  }

  FutureOr<void> _onLocateSong(event, emit) {
    if (state is AudioInfoSong &&
        (state as AudioInfoSong).indexPlaylist == state.playlist) {
      add(_AudioInfoUpdateIndex(event.index));
    } else {
      emit(AudioInfoSong(state.playlist!, state.buffer!, event.index,
          state.playlist, state.buffer, state.picture));
    }
  }

  FutureOr<void> _onLocatePlaylist(event, emit) async {
    List<Song> songList =
        await getIt<LoadFromDb>().getSongsByPlaylist(event.playlist);
    Uint8List picture =
        await getIt<LoadFromDb>().getCoverUint8ListByPlaylist(event.playlist);
    if (state is AudioInfoSong) {
      final songState = state as AudioInfoSong;
      emit(songState.copyWith(
        playlist: event.playlist,
        buffer: songList,
        picture: picture,
      ));
    } else {
      emit(AudioInfoPlaylist(event.playlist, songList, picture));
    }
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
