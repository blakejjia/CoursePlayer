import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/file_sys/providers/state.dart';

import '../func/load_db.dart' as loader;

/// Simple immutable state that describes current rebuild progress and status.

/// Riverpod provider for media library manager.
final mediaLibraryProvider =
    AsyncNotifierProvider<MediaLibraryNotifier, MediaLibraryState>(
  MediaLibraryNotifier.new,
);

class MediaLibraryNotifier extends AsyncNotifier<MediaLibraryState> {
  bool _cancelRequested = false;

  @override
  MediaLibraryState build() {
    // initial synchronous state
    return MediaLibraryState.initial();
  }

  /// Start a full rebuild. The [path] is the root directory to scan.
  /// The function updates the provider state with progress information.
  Future<void> rebuildAll(String path) async {
    // Avoid concurrent rebuilds
    if (_cancelRequested) return; // already cancelling/starting

    _cancelRequested = false;
    final current = state.value ?? MediaLibraryState.initial();
    state = AsyncValue.data(current.copyWith(isRebuilding: true, error: null));
    // Use the new callback-style API so the provider controls state and
    // cancellation directly.
    try {
      await loader.rebuildDbWithCallback(path, ref, (progress) {
        if (_cancelRequested) return;
        final cur = state.value ?? MediaLibraryState.initial();
        state = AsyncValue.data(cur.copyWith(
          currentFolder: progress['currentFolder'] ?? cur.currentFolder,
          totalFolder: progress['totalFolder'] ?? cur.totalFolder,
          currentFile: progress['currentFile'] ?? cur.currentFile,
          totalFile: progress['totalFile'] ?? cur.totalFile,
        ));
      }, () => _cancelRequested);

      final cur = state.value ?? MediaLibraryState.initial();
      state = AsyncValue.data(cur.copyWith(isRebuilding: false));
    } catch (e) {
      final cur = state.value ?? MediaLibraryState.initial();
      state = AsyncValue.data(
          cur.copyWith(isRebuilding: false, error: e.toString()));
    }
  }

  /// Cancel an in-progress rebuild if any.
  void cancelRebuild() {
    _cancelRequested = true;
    final cur = state.value ?? MediaLibraryState.initial();
    state = AsyncValue.data(cur.copyWith(isRebuilding: false));
  }

  /// Run a partial rebuild for a single folder and update the rebuilt time.
  /// Returns the same result code as the underlying utility (0 success, 1 error).
  Future<int> partialRebuild(String baseFolderPath) async {
    // Mark transient rebuilding state for single-folder update
    final cur = state.value ?? MediaLibraryState.initial();
    state = AsyncValue.data(cur.copyWith(isRebuilding: true, error: null));
    try {
      final result = await loader.partialRebuild(baseFolderPath, ref);
      final cur2 = state.value ?? MediaLibraryState.initial();
      state = AsyncValue.data(cur2.copyWith(isRebuilding: false));
      return result;
    } catch (e) {
      final cur2 = state.value ?? MediaLibraryState.initial();
      state = AsyncValue.data(
          cur2.copyWith(isRebuilding: false, error: e.toString()));
      return 1;
    }
  }
}
