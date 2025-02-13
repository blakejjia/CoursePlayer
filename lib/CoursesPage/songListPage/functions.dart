String formatDuration(int duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  int hours = duration ~/ 3600;
  int minutes = (duration % 3600) ~/ 60;
  int seconds = duration % 60;
  String twoDigitMinutes = twoDigits(minutes);
  String twoDigitSeconds = twoDigits(seconds);
  if (hours > 0) {
    return "${twoDigits(hours)}:$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

String formatTitle(String title) {
  int lastDotIndex = title.lastIndexOf('.');
  if (lastDotIndex != -1) {
    return title.substring(0, lastDotIndex);
  }
  return title;
}