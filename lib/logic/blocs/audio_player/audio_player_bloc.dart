import 'dart:async';
import 'package:course_player/data/models/models.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer audioPlayer;
  late StreamSubscription playerInfoStream;

  AudioPlayerBloc(this.audioPlayer) : super(AudioPlayerInitial()) {
    _initBloc();

    on<_UpdateState>(_onUpdatePlayerEvent);
    on<LocateAudio>(_onLocateAudio);

    on<PauseEvent>(_onPauseEvent);
    on<ContinueEvent>(_onContinueEvent);
    on<PreviousEvent>(_onPreviousEvent);
    on<NextEvent>(_onNextEvent);
    on<NextLoopMode>(_onNextLoopMode);
    on<NextShuffleMode>(_onSwitchShuffleMode);
    on<FinishedEvent>(_onFinished);
    on<SeekToPosition>(_onSeekToPosition);
  }

  void _initBloc() {
    playerInfoStream = CombineLatestStream.combine4(
      audioPlayer.playbackEventStream,
      audioPlayer.positionStream,
      audioPlayer.sequenceStateStream,
      audioPlayer.playerStateStream,
      (playbackEvent, position, sequenceState, playerState) => _UpdateState(
        position,
        playbackEvent,
        sequenceState,
        playerState,
        audioPlayer.duration,
      ),
    )
        .debounceTime(const Duration(milliseconds: 100))
        .listen((updateStateEvent) {
      add(updateStateEvent);
    });
  }

  FutureOr<void> _onFinished(event, emit) {
    audioPlayer.hasNext
        ? audioPlayer.seekToNext()
        : audioPlayer.seek(Duration.zero);
  }

  FutureOr<void> _onSeekToPosition(event, emit) {
    audioPlayer.seek(event.position);
  }

  FutureOr<void> _onNextEvent(event, emit) {
    audioPlayer.hasNext ? audioPlayer.seekToNext() : null;
  }

  FutureOr<void> _onPreviousEvent(event, emit) {
    audioPlayer.hasPrevious ? audioPlayer.seekToPrevious() : null;
  }

  FutureOr<void> _onLocateAudio(event, emit) async {
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: event.buffer.map<AudioSource>((song) {
          return AudioSource.file(song!.path); // 确保路径有效
        }).toList(), // 将 Iterable 转换为 List
      ),
    );
    await Future.wait([
      audioPlayer.seek(Duration.zero, index: event.index),
      audioPlayer.play(),
    ]);
    if (state is AudioPlayerInitial) {
      emit(AudioPlayerPlaying(Duration.zero, state.playbackEvent,
          state.sequenceState, state.playerState, state.totalTime));
    }
  }

  FutureOr<void> _onSwitchShuffleMode(event, emit) {
    final enable = !state.sequenceState.shuffleModeEnabled;
    if (enable) {
      audioPlayer.shuffle();
    }
    audioPlayer.setShuffleModeEnabled(enable);
  }

  FutureOr<void> _onNextLoopMode(event, emit) {
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(state.sequenceState.loopMode);
    audioPlayer.setLoopMode(cycleModes[(index + 1) % cycleModes.length]);
  }

  FutureOr<void> _onContinueEvent(event, emit) {
    audioPlayer.play();
  }

  FutureOr<void> _onPauseEvent(event, emit) {
    audioPlayer.pause();
  }

  FutureOr<void> _onUpdatePlayerEvent(event, emit) {
    emit(state.copyWith(
      position: event.position,
      playbackEvent: event.playbackEvent,
      sequenceState: event.sequenceState,
      playerState: event.playerState,
      totalTime: event.totalTime,
    ));
  }

  @override
  Future<void> close() {
    playerInfoStream.cancel();
    audioPlayer.dispose();
    return super.close();
  }
}
