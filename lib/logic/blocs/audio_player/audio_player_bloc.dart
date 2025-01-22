import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:lemon/data/models/models.dart';
import 'package:lemon/data/providers/load_from_db.dart';
import 'package:lemon/main.dart';
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
      : super(AudioPlayerState(const MediaItem(id: "0", title: "not playing"),
            PlaybackState(), 0)) {
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

    playerInfoStream = CombineLatestStream.combine2(
      audioHandler.playbackState,
      audioHandler.mediaItem,
      (playbackState, mediaItem) {
        return _UpdateState(
          mediaItem,
          playbackState,
        );
      },
    )
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

  FutureOr<void> _onSetSpeed(event, emit) async {
    double currentSpeed = event.speed;
    List<double> speedOptions = [1.0, 1.5, 1.7, 1.8, 2.0];
    int currentIndex = speedOptions.indexOf(currentSpeed);
    double proposedSpeed =
        speedOptions[(currentIndex + 1) % speedOptions.length];
    await audioHandler.setSpeed(proposedSpeed);
  }

  FutureOr<void> _onFinished(event, emit) async {
    await audioHandler.skipToNext();
  }

  FutureOr<void> _onSeekToPosition(event, emit) async {
    await audioHandler.seek(event.position);
  }

  FutureOr<void> _onNextEvent(event, emit) async {
    await audioHandler.skipToNext();
  }

  FutureOr<void> _onPreviousEvent(event, emit) async {
    await audioHandler.skipToPrevious();
  }

  void _onRewind(event, emit) async {
    await audioHandler.rewind();
  }

  Future<void> _onLocateAudio(event, emit) async {
    if (event.index == null ||
        event.playlistId == null ||
        event.position == null) return;

    List<Song>? songs =
        await getIt<LoadFromDb>().getSongsByPlaylistId(event.playlistId);
    emit(state.copyWith(currentPlaylist: event.playlistId));
    await audioHandler.locateAudio(
        songs!
            .whereType<Song>()
            .map((song) => MediaItem(
                  id: song.id.toString(),
                  title: song.title,
                  album: song.playlist,
                  displayDescription: song.path,
                  artist: song.artist,
                  genre: null,
                  duration: Duration(seconds: song.length),
                ))
            .cast<MediaItem>()
            .toList(),
        songs.map((song) => song.path).toList().cast<String>(),
        event.index,
        event.position);
  }

  FutureOr<void> _onSwitchShuffleMode(event, emit) async {
    AudioServiceShuffleMode currentShuffleMode =
        state.playbackState.shuffleMode;
    if (currentShuffleMode == AudioServiceShuffleMode.none) {
      currentShuffleMode = AudioServiceShuffleMode.all;
    } else {
      currentShuffleMode = AudioServiceShuffleMode.none;
    }

    // 设置新的 ShuffleMode
    await audioHandler.setShuffleMode(currentShuffleMode);
  }

  FutureOr<void> _onContinueEvent(event, emit) async {
    await audioHandler.play();
  }

  FutureOr<void> _onPauseEvent(event, emit) async {
    await audioHandler.pause();
  }

  @override
  Future<void> close() async {
    await playerInfoStream.cancel();
    return super.close();
  }
}
