part of 'audio_info_bloc.dart';

@immutable
sealed class AudioInfoState {
  final int index;
  final Playlist? playlist;
  final List<Song?> buffer;
  final Uint8List? image;

  const AudioInfoState(this.index, this.playlist, this.buffer, this.image);
}

final class AudioInfoIdle extends AudioInfoState {
  const AudioInfoIdle() : super(0, null, const [], null);
}

final class AudioInfoReady extends AudioInfoState {
  const AudioInfoReady(super.index, super.playlist, super.buffer, super.image);
}
