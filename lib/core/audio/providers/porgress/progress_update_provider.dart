import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A provider that notifies when progress has been updated
/// This allows UI components to react to progress changes without full reloads
class ProgressUpdateNotifier extends StateNotifier<DateTime> {
  ProgressUpdateNotifier() : super(DateTime.now());

  void notifyProgressUpdated() {
    state = DateTime.now();
  }
}

final progressUpdateProvider =
    StateNotifierProvider<ProgressUpdateNotifier, DateTime>((ref) {
  return ProgressUpdateNotifier();
});

/// A provider that tracks the current song's progress
/// This provides the latest progress without requiring a full song list reload
class CurrentSongProgressNotifier extends StateNotifier<Map<String, int>> {
  CurrentSongProgressNotifier() : super({});

  void updateProgress(String songId, int progressInSeconds) {
    state = {...state, songId: progressInSeconds};
  }

  int getProgress(String songId) {
    return state[songId] ?? 0;
  }
}

final currentSongProgressProvider =
    StateNotifierProvider<CurrentSongProgressNotifier, Map<String, int>>((ref) {
  return CurrentSongProgressNotifier();
});
