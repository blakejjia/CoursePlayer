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
  final int index;
  final Playlist indexPlaylist;
  final List<Song> indexBuffer;

  const AudioInfoSong(this.indexPlaylist, this.indexBuffer, this.index, super.playlist, super.buffer, super.picture);
  // copyWith method
  AudioInfoSong copyWith({
    int? index,
    Playlist? indexPlaylist,
    List<Song>? indexBuffer,
    Playlist? playlist,
    List<Song>? buffer,
    Uint8List? picture,
  }) {
    return AudioInfoSong(
      indexPlaylist ?? this.indexPlaylist,
      indexBuffer ?? this.indexBuffer,
      index ?? this.index,
      playlist ?? this.playlist,
      buffer ?? this.buffer,
      picture ?? this.picture,
    );
  }
}
