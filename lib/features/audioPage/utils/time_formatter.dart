String formatDuration(Duration duration) {
  String twoDigitMinutes =
      duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  String twoDigitSeconds =
      duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "$twoDigitMinutes:$twoDigitSeconds";
}
