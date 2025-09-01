/// Request model for the find-sequence endpoint
class FindSequenceRequest {
  /// Directory files as a string (comma-separated or JSON string)
  final String dirFiles;

  const FindSequenceRequest({
    required this.dirFiles,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'dir_files': dirFiles,
    };
  }

  /// Create from JSON
  factory FindSequenceRequest.fromJson(Map<String, dynamic> json) {
    return FindSequenceRequest(
      dirFiles: json['dir_files'] as String,
    );
  }

  @override
  String toString() {
    return 'FindSequenceRequest(dirFiles: $dirFiles)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FindSequenceRequest && other.dirFiles == dirFiles;
  }

  @override
  int get hashCode => dirFiles.hashCode;
}

/// Response model for the find-sequence endpoint
class FindSequenceResponse {
  /// Named segments mapping to arrays of filenames
  final Map<String, List<String>> sequence;

  const FindSequenceResponse({
    required this.sequence,
  });

  /// Create from JSON response
  factory FindSequenceResponse.fromJson(Map<String, dynamic> json) {
    final sequenceData = json['sequence'] as Map<String, dynamic>;
    final sequence = <String, List<String>>{};

    sequenceData.forEach((key, value) {
      sequence[key] = (value as List<dynamic>).cast<String>();
    });

    return FindSequenceResponse(
      sequence: sequence,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'sequence': sequence,
    };
  }

  /// Get all filenames in sequence order
  List<String> getAllFilenames() {
    final allFiles = <String>[];
    for (final segment in sequence.values) {
      allFiles.addAll(segment);
    }
    return allFiles;
  }

  /// Get segment names
  List<String> getSegmentNames() {
    return sequence.keys.toList();
  }

  /// Get files for a specific segment
  List<String> getFilesForSegment(String segmentName) {
    return sequence[segmentName] ?? [];
  }

  @override
  String toString() {
    return 'FindSequenceResponse(sequence: $sequence)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FindSequenceResponse &&
        _mapEquals(other.sequence, sequence);
  }

  @override
  int get hashCode => sequence.hashCode;

  /// Helper method to compare maps deeply
  bool _mapEquals(
      Map<String, List<String>> map1, Map<String, List<String>> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
      final list1 = map1[key]!;
      final list2 = map2[key]!;
      if (list1.length != list2.length) return false;
      for (int i = 0; i < list1.length; i++) {
        if (list1[i] != list2[i]) return false;
      }
    }
    return true;
  }
}

/// Error response model for find-sequence endpoint
class FindSequenceError {
  /// Error message
  final String message;

  /// HTTP status code
  final int statusCode;

  const FindSequenceError({
    required this.message,
    required this.statusCode,
  });

  /// Create from JSON error response
  factory FindSequenceError.fromJson(
      Map<String, dynamic> json, int statusCode) {
    return FindSequenceError(
      message: json['error'] ?? json['message'] ?? 'Unknown error',
      statusCode: statusCode,
    );
  }

  /// Create for common error cases
  factory FindSequenceError.badRequest([String? message]) {
    return FindSequenceError(
      message: message ?? 'Missing or invalid body.dir_files',
      statusCode: 400,
    );
  }

  factory FindSequenceError.unauthorized([String? message]) {
    return FindSequenceError(
      message: message ?? 'Unauthorized',
      statusCode: 401,
    );
  }

  factory FindSequenceError.forbidden([String? message]) {
    return FindSequenceError(
      message: message ?? 'Forbidden',
      statusCode: 403,
    );
  }

  factory FindSequenceError.serverError([String? message]) {
    return FindSequenceError(
      message: message ?? 'Server not configured or model error',
      statusCode: 500,
    );
  }

  @override
  String toString() {
    return 'FindSequenceError(statusCode: $statusCode, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FindSequenceError &&
        other.message == message &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => Object.hash(message, statusCode);
}
