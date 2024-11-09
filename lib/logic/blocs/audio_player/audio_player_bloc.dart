import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../services/audio_service.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  late final MyAudioHandler audioHandler;
  late StreamSubscription playerInfoStream;

  AudioPlayerBloc()
      : super(AudioPlayerState(
            const MediaItem(id: "0", title: "unknown"), PlaybackState())) {
    _initBloc();

    on<_UpdateState>(_onUpdateState);
    on<SetSpeed>(_onSetSpeed);
    on<LocateAudio>(_onLocateAudio);
    on<Rewind>(_onRewind);
    on<PauseEvent>(_onPauseEvent);
    on<ContinueEvent>(_onContinueEvent);
    on<PreviousEvent>(_onPreviousEvent);
    on<NextEvent>(_onNextEvent);
    on<NextShuffleMode>(_onSwitchShuffleMode);

    on<FinishedEvent>(_onFinished);
    on<SeekToPosition>(_onSeekToPosition);
  }

  void _initBloc() {
    audioHandler = getIt<MyAudioHandler>();

    playerInfoStream = CombineLatestStream.combine3(
      audioHandler.playbackState,
      audioHandler.mediaItem,
      audioHandler.queue,
      (playbackState, mediaItem, queue) {
        return _UpdateState(
          mediaItem,
          playbackState,
        );
      },
    )
        .debounceTime(const Duration(milliseconds: 100))
        .listen((updateStateEvent) {
      add(updateStateEvent);
    });
  }

  FutureOr<void> _onUpdateState(event, emit) {
    emit(state.copyWith(
      mediaItem: event.mediaItem,
      playbackState: event.playbackState,
    ));
  }

  FutureOr<void> _onSetSpeed(event, emit) {
    audioHandler.setSpeed(event.speed);
  }

  FutureOr<void> _onFinished(event, emit) {
    audioHandler.skipToNext();
  }

  FutureOr<void> _onSeekToPosition(event, emit) {
    audioHandler.seek(event.position);
  }

  FutureOr<void> _onNextEvent(event, emit) {
    audioHandler.skipToNext();
  }

  FutureOr<void> _onPreviousEvent(event, emit) {
    audioHandler.skipToPrevious();
  }

  void _onRewind(event, emit) async {
    audioHandler.rewind();
  }

  Future<void> _onLocateAudio(event, emit) async {
    await audioHandler.locateAudio(
      event.buffer.map((song) => song!.path).toList().cast<String>(),
      event.index,
    );
  }

  FutureOr<void> _onSwitchShuffleMode(event, emit) {
    audioHandler
        .setShuffleMode(AudioServiceShuffleMode.all); //TODO:点击变换shuffle mode
  }

  FutureOr<void> _onContinueEvent(event, emit) {
    audioHandler.play();
  }

  FutureOr<void> _onPauseEvent(event, emit) {
    audioHandler.pause();
  }

  @override
  Future<void> close() {
    playerInfoStream.cancel();
    return super.close();
  }
}
