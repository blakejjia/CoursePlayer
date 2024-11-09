import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/repositories/song_repository.dart';
import 'package:course_player/logic/services/audio_service.dart';
import 'package:course_player/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/providers/load_from_db.dart';

part 'audio_info_event.dart';
part 'audio_info_state.dart';

class AudioInfoBloc extends Bloc<AudioInfoEvent, AudioInfoState> {
  late StreamSubscription streamSubscription;
  late MyAudioHandler audioHandler;

  AudioInfoBloc() : super(const AudioInfoIdle()) {
    initBloc();
    on<AudioInfoLocatePlaylist>(_onLocatePlaylist);
    on<AudioInfoLocateSong>(_onLocateSong);
    on<_AudioInfoUpdate>(_onUpdateIndex);
  }

  FutureOr<void> _onUpdateIndex(event, emit) {
    if (state is AudioInfoSong) {
      final songState = state as AudioInfoSong;
      emit(songState.copyWith(song: event.song));
    }
  }

  void initBloc() {
    audioHandler = getIt<MyAudioHandler>();
    streamSubscription = audioHandler.mediaItem.asyncMap((mediaItem) async {
      final currentMediaItemId = mediaItem?.id ?? "0";
      return await getIt<SongRepository>()
          .getSongById(int.parse(currentMediaItemId));
    }).listen((song) {
      if (song != null) {
        add(_AudioInfoUpdate(song));
      }
    });
  }

  FutureOr<void> _onLocateSong(event, emit) {
    emit(
        AudioInfoSong(event.song, state.playlist, state.buffer, state.picture));
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
