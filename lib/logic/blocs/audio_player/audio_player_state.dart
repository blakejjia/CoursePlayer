part of 'audio_player_bloc.dart';

@immutable
sealed class AudioPlayerState {
  final Duration position;
  final PlaybackEvent playbackEvent;
  final SequenceState sequenceState;
  final PlayerState playerState;
  final Duration totalTime;

  const AudioPlayerState(this.position, this.playbackEvent, this.sequenceState,
      this.playerState, this.totalTime);

  AudioPlayerState copyWith({
    Duration? position,
    PlaybackEvent? playbackEvent,
    SequenceState? sequenceState,
    PlayerState? playerState,
    Duration? totalTime,
  });
}

final class AudioPlayerInitial extends AudioPlayerState {
  AudioPlayerInitial()
      : super(
            const Duration(),
            PlaybackEvent(),
            SequenceState([], 0, [0], false, LoopMode.off),
            PlayerState(false, ProcessingState.idle),
            const Duration());

  @override
  AudioPlayerInitial copyWith(
      {Duration? position,
      playbackEvent,
      sequenceState,
      playerState,
      Duration? totalTime}) {
    return AudioPlayerInitial();
  }


}

final class AudioPlayerPlaying extends AudioPlayerState {
  const AudioPlayerPlaying(super.position, super.playbackEvent,
      super.sequenceState, super.playerState, super.totalTime);

  @override
  AudioPlayerPlaying copyWith({
    Duration? position,
    PlaybackEvent? playbackEvent,
    SequenceState? sequenceState,
    PlayerState? playerState,
    Duration? totalTime,
  }) {
    return AudioPlayerPlaying(
      position ?? this.position,
      playbackEvent ?? this.playbackEvent,
      sequenceState ?? this.sequenceState,
      playerState ?? this.playerState,
      totalTime ?? this.totalTime,
    );
  }
}
