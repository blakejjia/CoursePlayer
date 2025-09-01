import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/playList/services/find_regex/models.dart';
import '../playlist_api_service.dart';

/// Service implementation for the find-filename-reg API
class FindRegexService {
  final PlaylistApiService _apiService;

  FindRegexService(this._apiService);

  /// Call the find-filename-reg API to infer RegExp pattern
  ///
  /// Sends directory file names to the backend AI model to analyze
  /// and returns a RegExp pattern that can split course filenames
  /// into sequence numbers and titles.
  Future<FindFilenameRegResponse> findFilenameRegex(
    FindFilenameRegRequest request,
  ) async {
    try {
      debugPrint('🔍 Calling find-filename-reg API with: ${request.dirFiles}');

      final response = await _apiService.post(
        '/courser/find-filename-reg',
        body: request.toJson(),
      );

      final regexResponse = FindFilenameRegResponse.fromJson(response);

      debugPrint('✅ Received RegExp pattern: ${regexResponse.regExp}');

      return regexResponse;
    } catch (e) {
      debugPrint('❌ Error calling find-filename-reg API: $e');
      rethrow;
    }
  }

  /// Convenience method to find regex pattern from a list of file names
  Future<FindFilenameRegResponse> findRegexFromFileNames(
    List<String> fileNames,
  ) async {
    final request = FindFilenameRegRequest.fromFileNames(fileNames);
    return findFilenameRegex(request);
  }

  /// Find regex pattern from media library songs for a specific album
  Future<FindFilenameRegResponse> findRegexFromAlbumSongs(
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

    return findRegexFromFileNames(fileNames);
  }

  /// Test a regex pattern against sample filenames and print results
  void printRegexTestResults(
    FindFilenameRegResponse response,
    List<String> sampleFiles,
  ) {
    debugPrint('🧪 Testing RegExp pattern: ${response.regExp}');
    debugPrint('📁 Sample files:');

    final results = response.testMultipleFiles(sampleFiles);

    for (final result in results) {
      final fileName = result['fileName'];
      final sequence = result['sequence'];
      final title = result['title'];

      if (sequence != null && title != null) {
        debugPrint('✅ $fileName -> Sequence: "$sequence", Title: "$title"');
      } else {
        debugPrint('❌ $fileName -> No match');
      }
    }
  }
}

/// Provider for FindRegexService
final findRegexServiceProvider = Provider<FindRegexService>((ref) {
  final apiService = ref.watch(playlistApiServiceProvider);
  return FindRegexService(apiService);
});

/// Provider for managing find regex operations with state
final findRegexProvider = StateNotifierProvider<FindRegexNotifier,
    AsyncValue<FindFilenameRegResponse?>>(
  (ref) => FindRegexNotifier(ref),
);

/// State notifier for managing find regex API calls
class FindRegexNotifier
    extends StateNotifier<AsyncValue<FindFilenameRegResponse?>> {
  final Ref ref;
  late final FindRegexService _service;

  FindRegexNotifier(this.ref) : super(const AsyncValue.data(null)) {
    _service = ref.read(findRegexServiceProvider);
  }

  /// Find regex pattern from file names
  Future<void> findRegexFromFiles(List<String> fileNames) async {
    if (fileNames.isEmpty) {
      state = AsyncValue.error('No file names provided', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final response = await _service.findRegexFromFileNames(fileNames);
      state = AsyncValue.data(response);

      // Print test results for debugging
      _service.printRegexTestResults(response, fileNames.take(5).toList());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Find regex pattern from songs in current album
  Future<void> findRegexFromCurrentAlbum(
      List<Map<String, dynamic>> songs) async {
    if (songs.isEmpty) {
      state = AsyncValue.error('No songs provided', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final response = await _service.findRegexFromAlbumSongs(songs);
      state = AsyncValue.data(response);

      // Extract sample file names for testing
      final sampleFiles = songs
          .take(5)
          .map((song) =>
              (song['path'] as String? ?? song['title'] as String? ?? ''))
          .where((path) => path.isNotEmpty)
          .map((path) => path.split('/').last.split('\\').last)
          .toList();

      _service.printRegexTestResults(response, sampleFiles);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Clear the current regex result
  void clearResult() {
    state = const AsyncValue.data(null);
  }
}

/// Extension methods for easier integration with existing media library
extension FindRegexMediaLibraryExtension on FindFilenameRegResponse {
  /// Apply the regex pattern to process song titles in a media library
  List<Map<String, dynamic>> processMediaLibrarySongs(
    List<Map<String, dynamic>> songs,
  ) {
    return songs.map((song) {
      final title = song['title'] as String? ?? '';
      final path = song['path'] as String? ?? '';

      // Try to extract filename from path if title is not useful
      final fileName =
          title.isNotEmpty ? title : path.split('/').last.split('\\').last;

      final match = testPattern(fileName);

      if (match != null) {
        return {
          ...song,
          'sequence': match['sequence'],
          'cleanTitle': match['title'],
          'originalTitle': title,
        };
      } else {
        return {
          ...song,
          'sequence': null,
          'cleanTitle': title,
          'originalTitle': title,
        };
      }
    }).toList();
  }
}
