part of 'audio_player_bloc.dart';

@immutable
sealed class AudioPlayerEvent {}

final class _UpdateState extends AudioPlayerEvent {
  final PlaybackState playbackState;
  final MediaItem? mediaItem;

  _UpdateState(this.mediaItem, this.playbackState);
}

final class PauseEvent extends AudioPlayerEvent {}

final class ContinueEvent extends AudioPlayerEvent {}

final class PreviousEvent extends AudioPlayerEvent {}

final class NextEvent extends AudioPlayerEvent {}

final class NextLoopMode extends AudioPlayerEvent {}

final class NextShuffleMode extends AudioPlayerEvent {}

final class SeekToPosition extends AudioPlayerEvent {
  final Duration position;

  SeekToPosition(this.position);
}

final class FinishedEvent extends AudioPlayerEvent {}

final class LocateAudio extends AudioPlayerEvent {
  final int? index;
  final int? playlistId;
  final int? position;

  LocateAudio(this.playlistId, this.index, this.position);
}

final class SetSpeed extends AudioPlayerEvent {
  final double speed;

  SetSpeed(this.speed);
}

final class Rewind extends AudioPlayerEvent {}
