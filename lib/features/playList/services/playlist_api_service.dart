import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service for communicating with the Courser cloud backend API
class PlaylistApiService {
  final String baseUrl;
  final String apiKey;

  PlaylistApiService({
    required this.baseUrl,
    required this.apiKey,
  });

  /// Make a POST request to the API
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    debugPrint('🌐 Making API request to: $url');
    final prettyBody = const JsonEncoder.withIndent('  ').convert(body);
    debugPrint('📤 Request body:\n$prettyBody', wrapWidth: 1024);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode(body),
      );

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData;
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw PlaylistApiException(
          'API request failed with status ${response.statusCode}',
          statusCode: response.statusCode,
          errorData: errorData,
        );
      }
    } catch (e) {
      if (e is PlaylistApiException) rethrow;

      debugPrint('❌ API request error: $e');
      throw PlaylistApiException('Network error: $e');
    }
  }

  /// Make a GET request to the API
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    debugPrint('🌐 Making GET request to: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'x-api-key': apiKey,
          'Access-Control-Allow-Origin': '*',
        },
      );

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData;
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw PlaylistApiException(
          'API request failed with status ${response.statusCode}',
          statusCode: response.statusCode,
          errorData: errorData,
        );
      }
    } catch (e) {
      if (e is PlaylistApiException) rethrow;

      debugPrint('❌ API request error: $e');
      throw PlaylistApiException('Network error: $e');
    }
  }
}

/// Exception thrown when API requests fail
class PlaylistApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errorData;

  PlaylistApiException(
    this.message, {
    this.statusCode,
    this.errorData,
  });

  @override
  String toString() {
    return 'PlaylistApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}

/// Provider for the PlaylistApiService
///
/// Note: You'll need to configure the actual base URL and API key
/// These should come from environment variables or configuration
final playlistApiServiceProvider = Provider<PlaylistApiService>((ref) {
  // These should come from environment configuration or settings
  const baseUrl =
      'https://courser.jia-blake-ca.workers.dev'; // Replace with actual worker URL
  const apiKey = 'I-love-courser-Always'; // Replace with actual API key

  return PlaylistApiService(
    baseUrl: baseUrl,
    apiKey: apiKey,
  );
});
