part of 'audio_info_bloc.dart';

@immutable
sealed class AudioInfoState {
  final Playlist? playlist;
  final List<Song>? buffer;
  final Uint8List? picture;

  const AudioInfoState(this.playlist, this.buffer, this.picture);
}

final class AudioInfoIdle extends AudioInfoState {
  const AudioInfoIdle() : super(null, const [], null);
}

final class AudioInfoPlaylist extends AudioInfoState {
  const AudioInfoPlaylist(super.playlist, super.buffer, super.picture);
}

final class AudioInfoSong extends AudioInfoState {
  final Song song;

  const AudioInfoSong(this.song, super.playlist, super.buffer, super.picture);
  // copyWith method
  AudioInfoSong copyWith({
    Song? song,
    Playlist? playlist,
    List<Song>? buffer,
    Uint8List? picture,
  }) {
    return AudioInfoSong(
      song ?? this.song,
      playlist ?? this.playlist,
      buffer ?? this.buffer,
      picture ?? this.picture,
    );
  }
}
