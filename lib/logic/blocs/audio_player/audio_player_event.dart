part of 'audio_player_bloc.dart';

@immutable
sealed class AudioPlayerEvent {}

final class _UpdateState extends AudioPlayerEvent {
  final Duration position;
  final PlaybackEvent playbackEvent;
  final SequenceState? sequenceState;
  final PlayerState playerState;
  final Duration? totalTime;
  final double speed;

  _UpdateState(this.position, this.speed, this.playbackEvent,
      this.sequenceState, this.playerState, this.totalTime);
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
  final int index;
  final List<Song?> buffer;

  LocateAudio(this.index, this.buffer);
}

final class SetSpeed extends AudioPlayerEvent {
  final double speed;

  SetSpeed(this.speed);
}

final class Replay10 extends AudioPlayerEvent {}
