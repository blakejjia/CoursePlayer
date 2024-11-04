part of 'audio_player_bloc.dart';

@immutable
sealed class AudioPlayerState {
  final Duration position;
  final PlaybackEvent playbackEvent;
  final SequenceState sequenceState;
  final Duration totalTime;

  const AudioPlayerState(
      this.position, this.playbackEvent, this.sequenceState, this.totalTime);

  AudioPlayerState copyWith({
    Duration? position,
    dynamic playbackEvent,
    dynamic sequenceState,
    Duration? totalTime,
  });
}

final class AudioPlayerInitial extends AudioPlayerState {
  AudioPlayerInitial()
      : super(const Duration(), PlaybackEvent(),
            SequenceState([], 0, [0], false, LoopMode.off), const Duration());

  @override
  AudioPlayerInitial copyWith(
      {Duration? position, playbackEvent, sequenceState,Duration? totalTime}) {
    return AudioPlayerInitial();
  }
}

final class AudioPlayerPlaying extends AudioPlayerState {
  const AudioPlayerPlaying(super.position, super.playbackEvent,
      super.sequenceState, super.totalTime);

  @override
  AudioPlayerPlaying copyWith({
    Duration? position,
    dynamic playbackEvent,
    dynamic sequenceState,
    Duration? totalTime,
  }) {
    return AudioPlayerPlaying(
      position ?? this.position,
      playbackEvent ?? this.playbackEvent,
      sequenceState ?? this.sequenceState,
      totalTime ?? this.totalTime,
    );
  }
}

final class AudioPlayerPause extends AudioPlayerState {
  const AudioPlayerPause(super.position, super.playbackEvent,
      super.sequenceState, super.totalTime);

  @override
  AudioPlayerPause copyWith({
    Duration? position,
    dynamic playbackEvent,
    dynamic sequenceState,
    Duration? totalTime,
  }) {
    return AudioPlayerPause(
      position ?? this.position,
      playbackEvent ?? this.playbackEvent,
      sequenceState ?? this.sequenceState,
      totalTime ?? this.totalTime,
    );
  }
}
