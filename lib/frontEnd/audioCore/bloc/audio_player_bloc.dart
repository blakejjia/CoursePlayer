import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:lemon/frontEnd/pages/CoursesPage/albumPage/bloc/album_page_cubit.dart';
import 'package:lemon/frontEnd/pages/CoursesPage/songListPage/bloc/song_lists_page_bloc.dart';
import 'package:lemon/backEnd/data/models/models.dart';
import 'package:lemon/backEnd/data/repositories/song_repository.dart';
import 'package:lemon/frontEnd/pages/settingsPage/bloc/settings_cubit.dart';
import 'package:lemon/main.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../backEnd/data/repositories/album_repository.dart';
import '../audio_service.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  /// [audioHandler] is the audio handler that controls the audio service
  /// it is used to control the audio service
  late final MyAudioHandler audioHandler;

  /// [playerInfoStream] is the stream that listens to the audio service
  /// it is used to update the state
  late StreamSubscription playerInfoStream;

  AudioPlayerBloc() : super(AudioPlayerInitial()) {
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

    // make to default playback speed
    double defaultPlaybackRate =
        getIt<SettingsCubit>().state.defaultPlaybackSpeed;
    add(SetSpeed(defaultPlaybackRate));
  }

  void _initBloc() async {
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
    ).listen((updateStateEvent) {
      add(updateStateEvent);
    });
  }

  /// Core function, updates database and state
  FutureOr<void> _onUpdateState(event, emit) {
    if (state is AudioPlayerIdeal) {
      emit((state as AudioPlayerIdeal).copyWith(
        mediaItem: event.mediaItem,
        playbackState: event.playbackState,
      ));
      if (event.playbackState.playing) {
        // update song progresses
        getIt<SongRepository>().updateSongProgress(
            int.parse(event.mediaItem.id),
            event.playbackState.position.inSeconds);
        getIt<AlbumPageCubit>().updateHistory(LatestPlayed(
            (state as AudioPlayerIdeal).album, int.parse(event.mediaItem.id)));
      }
    }
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
    List<Song>? songs = (event.buffer) ??
        await getIt<SongRepository>().getSongsByAlbumId(event.album.id);
    int index = songs!.indexWhere((song) => song.id == event.songId);
    songs = songs.sublist(index);
    int position = songs[0].playedInSecond;

    emit(AudioPlayerIdeal(
        MediaItem(id: '', title: ''), PlaybackState(), event.album));

    await audioHandler.locateAudio(
        songs
            .whereType<Song>()
            .map((song) => MediaItem(
                  id: song.id.toString(),
                  title: song.title,
                  album: "${song.album}",
                  displayDescription: song.path,
                  artist: song.artist,
                  genre: null,
                  duration: Duration(seconds: song.length),
                ))
            .cast<MediaItem>()
            .toList(),
        songs.map((song) => song.path).toList().cast<String>(),
        0,
        position);
  }

  FutureOr<void> _onSwitchShuffleMode(event, emit) async {
    AudioServiceShuffleMode currentShuffleMode =
        (state as AudioPlayerIdeal).playbackState.shuffleMode;
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
    await getIt<AlbumRepository>().updateLastPlayedSongWithId(
        int.parse((state as AudioPlayerIdeal).mediaItem.album!),
        int.parse((state as AudioPlayerIdeal).mediaItem.id));
    // refresh blocs
    getIt<SongListPageBloc>().add(UpdateSongListEvent());
    getIt<AlbumPageCubit>().load();
  }

  @override
  Future<void> close() async {
    await playerInfoStream.cancel();
    return super.close();
  }
}
