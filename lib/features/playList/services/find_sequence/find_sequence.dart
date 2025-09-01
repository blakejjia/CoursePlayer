import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/playList/services/find_sequence/models.dart';
import '../playlist_api_service.dart';

/// Service implementation for the find-sequence API
class FindSequenceService {
  final PlaylistApiService _apiService;

  FindSequenceService(this._apiService);

  /// Call the find-sequence API to infer a logical playback/study order
  ///
  /// Sends directory file names to the backend AI model to analyze
  /// and returns a sequence object with named segments mapping to
  /// arrays of filenames in logical order.
  Future<FindSequenceResponse> findSequence(
    FindSequenceRequest request,
  ) async {
    try {
      debugPrint('📚 Calling find-sequence API with: ${request.toJson()}');

      final response = await _apiService.post(
        '/api/courser/find-sequence',
        body: request.toJson(),
      );

      final sequenceResponse = FindSequenceResponse.fromJson(response);

      debugPrint(
          '✅ Received sequence with ${sequenceResponse.sequence.length} segments');
      debugPrint('📝 Segments: ${sequenceResponse.getSegmentNames()}');

      return sequenceResponse;
    } catch (e) {
      debugPrint('❌ Error calling find-sequence API: $e');
      rethrow;
    }
  }

  /// Convenience method to find sequence from a list of file names
  Future<FindSequenceResponse> findSequenceFromFileNames(
    List<String> fileNames,
  ) async {
    final request = FindSequenceRequest(
      dirFiles: fileNames.join(','),
    );
    return findSequence(request);
  }

  /// Find sequence from media library songs for a specific album
  Future<FindSequenceResponse> findSequenceFromAlbumSongs(
    List<Map<String, dynamic>> songs,
  ) async {
    // Extract file names from song paths
    final fileNames = songs
        .map(
            (song) => song['path'] as String? ?? song['title'] as String? ?? '')
        .where((path) => path.isNotEmpty)
        .map((path) => path.split('/').last.split('\\').last)
        .toList();

    if (fileNames.isEmpty) {
      throw Exception('No valid file names found in songs');
    }

    return findSequenceFromFileNames(fileNames);
  }

  /// Print sequence results for debugging
  void printSequenceResults(
    FindSequenceResponse response,
    List<String> originalFiles,
  ) {
    debugPrint('📚 Sequence Analysis Results:');
    debugPrint('📁 Original files count: ${originalFiles.length}');
    debugPrint('🔢 Segments found: ${response.sequence.length}');

    for (final segmentName in response.getSegmentNames()) {
      final files = response.getFilesForSegment(segmentName);
      debugPrint('📂 Segment "$segmentName": ${files.length} files');
      for (int i = 0; i < files.length && i < 3; i++) {
        debugPrint('   ${i + 1}. ${files[i]}');
      }
      if (files.length > 3) {
        debugPrint('   ... and ${files.length - 3} more');
      }
    }
  }
}

/// Provider for FindSequenceService
final findSequenceServiceProvider = Provider<FindSequenceService>((ref) {
  final apiService = ref.watch(playlistApiServiceProvider);
  return FindSequenceService(apiService);
});

/// Provider for managing find sequence operations with state
final findSequenceProvider = StateNotifierProvider<FindSequenceNotifier,
    AsyncValue<FindSequenceResponse?>>(
  (ref) => FindSequenceNotifier(ref),
);

/// State notifier for managing find sequence API calls
class FindSequenceNotifier
    extends StateNotifier<AsyncValue<FindSequenceResponse?>> {
  final Ref ref;
  late final FindSequenceService _service;

  FindSequenceNotifier(this.ref) : super(const AsyncValue.data(null)) {
    _service = ref.read(findSequenceServiceProvider);
  }

  /// Find sequence from file names
  Future<void> findSequenceFromFiles(List<String> fileNames) async {
    if (fileNames.isEmpty) {
      state = AsyncValue.error('No file names provided', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final response = await _service.findSequenceFromFileNames(fileNames);
      state = AsyncValue.data(response);

      // Print sequence results for debugging
      _service.printSequenceResults(response, fileNames);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Find sequence from songs in current album
  Future<void> findSequenceFromCurrentAlbum(
      List<Map<String, dynamic>> songs) async {
    if (songs.isEmpty) {
      state = AsyncValue.error('No songs provided', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final response = await _service.findSequenceFromAlbumSongs(songs);
      state = AsyncValue.data(response);

      // Extract original file names for debugging
      final originalFiles = songs
          .map((song) =>
              (song['path'] as String? ?? song['title'] as String? ?? ''))
          .where((path) => path.isNotEmpty)
          .map((path) => path.split('/').last.split('\\').last)
          .toList();

      _service.printSequenceResults(response, originalFiles);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Clear the current sequence result
  void clearResult() {
    state = const AsyncValue.data(null);
  }
}

/// Extension methods for easier integration with existing media library
extension FindSequenceMediaLibraryExtension on FindSequenceResponse {
  /// Apply the sequence to reorder songs in a media library
  List<Map<String, dynamic>> applySongSequence(
    List<Map<String, dynamic>> songs,
  ) {
    final reorderedSongs = <Map<String, dynamic>>[];
    final allFiles = getAllFilenames();

    // Create a map of filename to song for quick lookup
    final songMap = <String, Map<String, dynamic>>{};
    for (final song in songs) {
      final title = song['title'] as String? ?? '';
      final path = song['path'] as String? ?? '';
      final fileName =
          title.isNotEmpty ? title : path.split('/').last.split('\\').last;
      songMap[fileName] = song;
    }

    // Add songs in sequence order
    for (final fileName in allFiles) {
      final song = songMap[fileName];
      if (song != null) {
        reorderedSongs.add({
          ...song,
          'sequenceOrder': reorderedSongs.length + 1,
        });
        songMap.remove(fileName); // Remove processed songs
      }
    }

    // Add any remaining songs that weren't matched
    for (final remainingSong in songMap.values) {
      reorderedSongs.add({
        ...remainingSong,
        'sequenceOrder': null, // Mark as unsequenced
      });
    }

    return reorderedSongs;
  }

  /// Get segment information for UI display
  List<Map<String, dynamic>> getSegmentInfo() {
    return sequence.entries.map((entry) {
      return {
        'name': entry.key,
        'files': entry.value,
        'count': entry.value.length,
      };
    }).toList();
  }
}
