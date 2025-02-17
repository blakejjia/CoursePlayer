import 'package:lemon/CoursesPage/songListPage/bloc/song_lists_page_bloc.dart';

import '../../common/data/models/models.dart';



/// format title to fit the screen
/// - remove file extension
String formatTitle(Song song) {
  String title = song.title;
  int lastDotIndex = title.lastIndexOf('.');
  if (lastDotIndex != -1) {
    title = title.substring(0, lastDotIndex);
  }
  if (title.length > 20) {
    return '${title.substring(0, 20)}...';
  }
  return title;
}

/// subtitle contains:
/// - played time in percentage
/// - artist (washed)
/// - duration
String formatSubtitle(Song song) {
  String playedPercentage = song.playedInSecond == 0 ? '' : '${(song.playedInSecond / song.length * 100).toStringAsFixed(0)}%';
  String duration = () {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    int hours = song.length ~/ 3600;
    int minutes = (song.length % 3600) ~/ 60;
    int seconds = song.length % 60;
    String twoDigitMinutes = twoDigits(minutes);
    String twoDigitSeconds = twoDigits(seconds);
    if (hours > 0) {
      return "${twoDigits(hours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }();
  return '${playedPercentage.isNotEmpty ? '$playedPercentage | ' : ''}${song.artist} | $duration';
}

String contiButton(SongListPageReady state){
  return state.album.lastPlayedIndex == -1
      ? "start playing"
      : "continue songId: #${state.album.lastPlayedIndex}";
}
