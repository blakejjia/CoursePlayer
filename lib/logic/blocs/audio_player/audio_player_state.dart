part of 'audio_player_bloc.dart';

@immutable
sealed class AudioPlayerState {
  final Duration position;
  final double speed;
  final PlaybackEvent playbackEvent;
  final SequenceState sequenceState;
  final PlayerState playerState;

  const AudioPlayerState(this.position, this.speed, this.playbackEvent,
      this.sequenceState, this.playerState);
  AudioPlayerState copyWith(
      {Duration? position,
      double? speed,
      PlaybackEvent? playbackEvent,
      SequenceState? sequenceState,
      PlayerState? playerState});
}

final class AudioPlayerInitial extends AudioPlayerState {
  AudioPlayerInitial()
      : super(
            const Duration(),
            1,
            PlaybackEvent(),
            SequenceState([], 0, [0], false, LoopMode.off),
            PlayerState(false, ProcessingState.idle));

  @override
  AudioPlayerInitial copyWith(
      {Duration? position, double? speed, playbackEvent, sequenceState, playerState}) {
    return AudioPlayerInitial();
  }
}

final class AudioPlayerPlaying extends AudioPlayerState {
  const AudioPlayerPlaying(super.position, super.speed, super.playbackEvent,
      super.sequenceState, super.playerState);

  @override
  AudioPlayerPlaying copyWith({
    Duration? position,
    double? speed,
    PlaybackEvent? playbackEvent,
    SequenceState? sequenceState,
    PlayerState? playerState,
  }) {
    return AudioPlayerPlaying(
      position ?? this.position,
      speed ?? this.speed,
      playbackEvent ?? this.playbackEvent,
      sequenceState ?? this.sequenceState,
      playerState ?? this.playerState,
    );
  }
}
