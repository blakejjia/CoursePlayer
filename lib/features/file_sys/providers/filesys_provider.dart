import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/file_sys/func/load_db.dart';
import 'package:lemon/features/file_sys/providers/state.dart';

/// Simple immutable state that describes current rebuild progress and status.

/// Riverpod provider for media library manager.
final mediaLibraryProvider =
    AsyncNotifierProvider<MediaLibraryNotifier, MediaLibraryState>(
  MediaLibraryNotifier.new,
);

class MediaLibraryNotifier extends AsyncNotifier<MediaLibraryState> {
  @override
  MediaLibraryState build() {
    // initial synchronous state
    return MediaLibraryState.initial();
  }

  /// Combined rebuild entry. If the app has a recorded `dbRebuiltTime` in
  /// settings then perform an incremental (partial) rebuild; otherwise run a
  /// full rebuild. Returns 0 on success, 1 on error.
  Future<int> rebuild(String path) async {
    final cur = state.value ?? MediaLibraryState.initial();
    state = AsyncValue.data(cur.copyWith(isRebuilding: true, error: null));
    try {
      await loadDb(path, ref, (progress) {
        // Use the most recent state snapshot so we don't overwrite
        // transient fields like `isRebuilding` that may have been set
        // after `cur` was captured above.
        final latest = state.value ?? MediaLibraryState.initial();
        state = AsyncValue.data(latest.copyWith(
          currentFolder: progress['currentFolder'] ?? latest.currentFolder,
          totalFolder: progress['totalFolder'] ?? latest.totalFolder,
          currentFile: progress['currentFile'] ?? latest.currentFile,
          totalFile: progress['totalFile'] ?? latest.totalFile,
        ));
      });
      final cur2 = state.value ?? MediaLibraryState.initial();
      state = AsyncValue.data(cur2.copyWith(isRebuilding: false));
      return 0;
    } catch (e) {
      final cur2 = state.value ?? MediaLibraryState.initial();
      state = AsyncValue.data(
          cur2.copyWith(isRebuilding: false, error: e.toString()));
      return 1;
    }
  }
}
