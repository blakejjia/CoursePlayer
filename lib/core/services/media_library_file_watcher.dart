import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../data/json/models/media_library_schema.dart';
import '../../main.dart';

/// A service that watches the MediaLibrary.json file for changes
/// and automatically updates the UI when the file is modified
class MediaLibraryFileWatcher {
  final Ref ref;
  StreamSubscription<FileSystemEvent>? _watchSubscription;
  File? _jsonFile;
  bool _isWatching = false;
  Timer? _debounceTimer;

  MediaLibraryFileWatcher(this.ref);

  /// Start watching the MediaLibrary.json file
  Future<void> startWatching() async {
    if (_isWatching) return;

    try {
      // Get the MediaLibrary.json file path
      final dir = await getApplicationDocumentsDirectory();
      _jsonFile = File(p.join(dir.path, 'MediaLibrary.json'));

      if (!await _jsonFile!.exists()) {
        debugPrint('MediaLibrary.json not found, will watch for creation');
        // Watch the directory for file creation
        _watchSubscription =
            dir.watch(events: FileSystemEvent.all).listen(_onFileEvent);
      } else {
        // Watch the file directly
        _watchSubscription =
            _jsonFile!.watch(events: FileSystemEvent.all).listen(_onFileEvent);
      }

      _isWatching = true;
      debugPrint('Started watching MediaLibrary.json for changes');
    } catch (e) {
      debugPrint('Error starting file watcher: $e');
    }
  }

  /// Stop watching the file
  void stopWatching() {
    _watchSubscription?.cancel();
    _watchSubscription = null;
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _isWatching = false;
    debugPrint('Stopped watching MediaLibrary.json');
  }

  /// Handle file system events
  void _onFileEvent(FileSystemEvent event) {
    // Check if the event is for our MediaLibrary.json file
    if (event.path.endsWith('MediaLibrary.json')) {
      debugPrint('MediaLibrary.json ${event.type} detected');

      // Debounce rapid file changes (like during saving)
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _handleFileChange(event);
      });
    }
  }

  /// Handle the actual file change after debouncing
  void _handleFileChange(FileSystemEvent event) async {
    try {
      switch (event.type) {
        case FileSystemEvent.modify:
        case FileSystemEvent.create:
          await _reloadData();
          break;
        case FileSystemEvent.delete:
          debugPrint('MediaLibrary.json was deleted');
          break;
        case FileSystemEvent.move:
          debugPrint('MediaLibrary.json was moved');
          break;
        default:
          break;
      }
    } catch (e) {
      debugPrint('Error handling file change: $e');
    }
  }

  /// Reload data from the JSON file and notify providers
  Future<void> _reloadData() async {
    try {
      debugPrint('Reloading data from MediaLibrary.json due to file change');

      // Force reload from the JSON store using the new public method
      final store = ref.read(jsonStoreProvider);

      // Use the new forceReload method which handles everything
      final newData = await store.forceReload();

      debugPrint(
          'Successfully reloaded data: ${newData.songs.length} songs, ${newData.albums.length} albums');
    } catch (e) {
      debugPrint('Error reloading data: $e');
    }
  }

  /// Check if currently watching
  bool get isWatching => _isWatching;

  /// Dispose and clean up resources
  void dispose() {
    stopWatching();
  }
}

/// Provider for the file watcher service
final mediaLibraryFileWatcherProvider =
    Provider<MediaLibraryFileWatcher>((ref) {
  final watcher = MediaLibraryFileWatcher(ref);

  // Auto-start watching when the provider is created
  watcher.startWatching();

  // Dispose when the provider is disposed
  ref.onDispose(() {
    watcher.dispose();
  });

  return watcher;
});

/// A provider that notifies when the MediaLibrary.json file changes
/// UI components can watch this to automatically update
class MediaLibraryChangeNotifier extends StateNotifier<DateTime> {
  final MediaLibraryFileWatcher _watcher;
  StreamSubscription<MediaLibraryFileRoot>? _changeSubscription;

  MediaLibraryChangeNotifier(this._watcher) : super(DateTime.now()) {
    _listenToChanges();
  }

  void _listenToChanges() {
    final store = _watcher.ref.read(jsonStoreProvider);
    _changeSubscription = store.changes.listen((_) {
      // Notify that the data has changed
      state = DateTime.now();
    });
  }

  @override
  void dispose() {
    _changeSubscription?.cancel();
    super.dispose();
  }
}

final mediaLibraryChangeProvider =
    StateNotifierProvider<MediaLibraryChangeNotifier, DateTime>((ref) {
  final watcher = ref.watch(mediaLibraryFileWatcherProvider);
  return MediaLibraryChangeNotifier(watcher);
});
