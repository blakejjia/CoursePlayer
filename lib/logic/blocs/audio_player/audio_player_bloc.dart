import 'dart:async';
import 'package:course_player/data/models/models.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final _audioPlayer = AudioPlayer();
  late StreamSubscription playerInfoStream;

  AudioPlayerBloc() : super(AudioPlayerInitial()) {
    _initializeAudioPlayer();

    on<_UpdateState>(_onUpdatePlayerEvent);
    on<PauseEvent>(_onPauseEvent);
    on<ContinueEvent>(_onContinueEvent);
    on<PreviousEvent>((event, emit) {
      _audioPlayer.hasPrevious ? _audioPlayer.seekToPrevious() : null;
    });
    on<NextEvent>((event, emit) {
      _audioPlayer.hasNext ? _audioPlayer.seekToNext() : null;
    });
    on<NextLoopMode>(_onNextLoopMode);
    on<SwitchShuffleMode>(_onSwitchShuffleMode);
    on<SeekToPosition>((event, emit) {
      _audioPlayer.seek(event.position);
    });
    on<FinishedEvent>((event, emit) {
      _audioPlayer.hasNext
          ? _audioPlayer.seekToNext()
          : _audioPlayer.seek(const Duration(seconds: 0));
    });
    on<LocateAudio>((event, emit) {
      _audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: event.buffer.map((song) {
            return AudioSource.file(song!.path); // 确保路径有效
          }).toList(), // 将 Iterable 转换为 List
        ),
      );
      _audioPlayer.seek(Duration.zero, index: event.index);
      _audioPlayer.play();
      emit(AudioPlayerPlaying(state.position, state.playbackEvent,
          state.sequenceState, state.totalTime));
    });
  }

  FutureOr<void> _onSwitchShuffleMode(event, emit) {
    final enable = !state.sequenceState.shuffleModeEnabled;
    if (enable) {
      _audioPlayer.shuffle();
    }
    _audioPlayer.setShuffleModeEnabled(enable);
  }

  FutureOr<void> _onNextLoopMode(event, emit) {
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(state.sequenceState.loopMode);
    _audioPlayer.setLoopMode(cycleModes[(index + 1) % cycleModes.length]);
  }

  FutureOr<void> _onContinueEvent(event, emit) {
    _audioPlayer.play();
    emit(AudioPlayerPlaying(state.position, state.playbackEvent,
        state.sequenceState, state.totalTime));
  }

  FutureOr<void> _onPauseEvent(event, emit) {
    _audioPlayer.pause();
    emit(AudioPlayerPause(state.position, state.playbackEvent,
        state.sequenceState, state.totalTime));
  }

  FutureOr<void> _onUpdatePlayerEvent(event, emit) {
    emit(state.copyWith(
      position: event.position,
      playbackEvent: event.playbackEvent,
      sequenceState: event.sequenceState,
      totalTime: event.totalTime,
    ));
  }

  void _initializeAudioPlayer() {
    playerInfoStream = _audioPlayer.playbackEventStream.listen((playbackEvent) {
      _audioPlayer.positionStream.listen((position) {
        _audioPlayer.sequenceStateStream.listen((sequenceState) {
          add(_UpdateState(
            position,
            playbackEvent,
            sequenceState,
            _audioPlayer.duration,
          ));
        });
      });
    });
  }

  @override
  Future<void> close() {
    playerInfoStream.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
