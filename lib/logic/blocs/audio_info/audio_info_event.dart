part of 'audio_info_bloc.dart';

@immutable
sealed class AudioInfoEvent {}

final class LocateSong extends AudioInfoEvent{
  final int index;

  LocateSong(this.index);
}