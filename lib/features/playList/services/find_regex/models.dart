import 'package:flutter/foundation.dart';

/// Request model for the find-filename-reg API
/// Sends directory files information to infer RegExp pattern
class FindFilenameRegRequest {
  /// List of file names from a directory to analyze for pattern detection
  final String dirFiles;

  const FindFilenameRegRequest({
    required this.dirFiles,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() => {
        'dir_files': dirFiles,
      };

  /// Create from file names list - joins multiple filenames with newlines
  factory FindFilenameRegRequest.fromFileNames(List<String> fileNames) {
    return FindFilenameRegRequest(
      dirFiles: fileNames.join('\n'),
    );
  }

  /// Create from directory path by extracting filenames
  /// This would typically be used with actual file system scanning
  factory FindFilenameRegRequest.fromDirectoryContents(
    List<String> filePaths,
  ) {
    // Extract just the filenames from full paths
    final fileNames =
        filePaths.map((path) => path.split('/').last.split('\\').last).toList();
    return FindFilenameRegRequest.fromFileNames(fileNames);
  }

  @override
  String toString() => 'FindFilenameRegRequest(dirFiles: $dirFiles)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FindFilenameRegRequest && other.dirFiles == dirFiles;
  }

  @override
  int get hashCode => dirFiles.hashCode;
}

/// Response model for the find-filename-reg API
/// Contains the inferred Dart RegExp pattern for splitting filenames
class FindFilenameRegResponse {
  /// The Dart RegExp string that can split course file names into sequence and title
  final String regExp;

  const FindFilenameRegResponse({
    required this.regExp,
  });

  /// Create from JSON response
  factory FindFilenameRegResponse.fromJson(Map<String, dynamic> json) {
    return FindFilenameRegResponse(
      regExp: json['RegExp'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'RegExp': regExp,
      };

  /// Get the actual RegExp object for use in Dart code
  RegExp get regExpObject {
    try {
      return RegExp(regExp);
    } catch (e) {
      debugPrint('Error creating RegExp from: $regExp, error: $e');
      // Fallback to a basic pattern if the server response is invalid
      return RegExp(r'(\d+)[\s\-_\.]*(.+)');
    }
  }

  /// Test the RegExp pattern against a filename
  /// Returns a map with 'sequence' and 'title' if match found, null otherwise
  Map<String, String>? testPattern(String fileName) {
    final match = regExpObject.firstMatch(fileName);
    if (match != null && match.groupCount >= 2) {
      return {
        'sequence': match.group(1) ?? '',
        'title': match.group(2) ?? '',
      };
    }
    return null;
  }

  /// Test the pattern against multiple filenames and return results
  List<Map<String, String?>> testMultipleFiles(List<String> fileNames) {
    return fileNames.map((fileName) {
      final result = testPattern(fileName);
      return {
        'fileName': fileName,
        'sequence': result?['sequence'],
        'title': result?['title'],
      };
    }).toList();
  }

  @override
  String toString() => 'FindFilenameRegResponse(regExp: $regExp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FindFilenameRegResponse && other.regExp == regExp;
  }

  @override
  int get hashCode => regExp.hashCode;
}
