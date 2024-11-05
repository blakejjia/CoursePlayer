part of 'audio_player_bloc.dart';

@immutable
sealed class AudioPlayerEvent {}

final class _UpdateState extends AudioPlayerEvent {
  final Duration position;
  final PlaybackEvent playbackEvent;
  final SequenceState? sequenceState;
  final Duration? totalTime;

  _UpdateState(
      this.position, this.playbackEvent, this.sequenceState, this.totalTime);
}

final class PauseEvent extends AudioPlayerEvent {}

final class ContinueEvent extends AudioPlayerEvent {}

final class PreviousEvent extends AudioPlayerEvent {}

final class NextEvent extends AudioPlayerEvent {}

final class NextLoopMode extends AudioPlayerEvent {}

final class SwitchShuffleMode extends AudioPlayerEvent {}

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
