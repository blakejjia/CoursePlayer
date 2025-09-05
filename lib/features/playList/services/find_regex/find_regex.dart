import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:lemon/features/playList/services/find_regex/models.dart';
import '../playlist_api_service.dart';

/// Service implementation for the find-filename-reg API
class FindRegexService extends ChangeNotifier {
  final PlaylistApiService _apiService;

  // Internal AsyncValue state that UI expects (when / isLoading / value)
  AsyncValue<FindFilenameRegResponse?> _state = const AsyncValue.data(null);

  FindRegexService(this._apiService);

  // Expose AsyncValue-like API so existing UI code can call methods
  // directly on the service instance returned by ref.watch(ref).
  AsyncValue<FindFilenameRegResponse?> get state => _state;

  bool get isLoading => _state.isLoading;

  FindFilenameRegResponse? get value => _state.value;

  T when<T>({
    required T Function(FindFilenameRegResponse? data) data,
    required T Function() loading,
    required T Function(Object error, StackTrace? stackTrace) error,
  }) {
    return _state.when(data: data, loading: loading, error: error);
  }

  /// Call the find-filename-reg API to infer RegExp pattern and update
  /// internal state so UI can react to loading/data/error.
  Future<FindFilenameRegResponse?> findAlbumRegex(
    Album album,
  ) async {
    try {
      debugPrint('🔍 Calling find-filename-reg API with: ${album.title}');

      _state = const AsyncValue.loading();
      notifyListeners();

      final response = await _apiService.post(
        '/api/courser/find-filename-reg',
        body: FindFilenameRegRequest.fromAlbum(album, null).toJson(),
      );

      final regexResponse = FindFilenameRegResponse.fromJson(response);
      debugPrint('✅ Received RegExp pattern: ${regexResponse.toString()}');

      _state = AsyncValue.data(regexResponse);
      notifyListeners();

      return regexResponse;
    } catch (e, st) {
      debugPrint('❌ Error calling find-filename-reg API: $e');
      _state = AsyncValue.error(e, st);
      notifyListeners();
      rethrow;
    }
  }
}

/// Provider for FindRegexService
final findRegexServiceProvider =
    ChangeNotifierProvider<FindRegexService>((ref) {
  final apiService = ref.watch(playlistApiServiceProvider);
  return FindRegexService(apiService);
});
