import 'package:lemon/core/data/models/models.dart';

/// Request model for the find-filename-reg API
/// Sends directory files information to infer RegExp pattern
class FindFilenameRegRequest {
  final List<String> album;
  final String? userPrompt;

  const FindFilenameRegRequest({
    required this.album,
    this.userPrompt,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() => {
        'album': album.toString(),
        if (userPrompt != null) 'userPrompt': userPrompt,
      };

  /// Create from directory path by extracting filenames
  /// This would typically be used with actual file system scanning
  factory FindFilenameRegRequest.fromAlbum(
    Album album,
    String? userPrompt,
  ) {
    return FindFilenameRegRequest(
      album: album.songs.map((e) => e.title).toList(),
      userPrompt: userPrompt ?? " ",
    );
  }

  @override
  String toString() => 'FindFilenameRegRequest(albumCount: ${album.length})';
}

/// Response model for the find-filename-reg API
/// Contains the inferred Dart RegExp pattern for splitting filenames
class FindFilenameRegResponse {
  /// New response schema fields
  /// - trackRef: regex string to find the track reference, e.g. "wj\d{4}"
  /// - alias: regex string with a capture group for the title, e.g. "^wj\d{4}[-：](.*)"
  /// - unwanted: list of regex strings; filenames matching any of these should be ignored
  final String trackRef;
  final String alias;
  final List<String> unwanted;

  const FindFilenameRegResponse({
    required this.trackRef,
    required this.alias,
    required this.unwanted,
  });

  /// Create from JSON response following the new schema
  factory FindFilenameRegResponse.fromJson(Map<String, dynamic> json) {
    return FindFilenameRegResponse(
      trackRef: (json['trackRef'] as String?) ?? r'wj\\d{4}',
      alias: (json['alias'] as String?) ?? r'^wj\\d{4}[-：](.*)',
      unwanted:
          (json['unwanted'] as List<dynamic>?)?.cast<String>() ?? <String>[],
    );
  }

  /// the RegExp object for trackRef
  RegExp get trackRefObject {
    return RegExp(trackRef);
  }

  RegExp get aliasObject {
    return RegExp(alias);
  }

  List<RegExp> get unwantedObjects {
    return unwanted.map((s) => RegExp(s)).toList();
  }

  /// Apply the RegExp patterns to a given file name
  Map<String, String>? applyPattern(String fileName) {
    // trackRef
    final trackRef = trackRefObject.firstMatch(fileName);

    // alias
    var cleaned = aliasObject.firstMatch(fileName)?.group(1) ?? fileName;
    for (final re in unwantedObjects) {
      cleaned = cleaned.replaceAll(re, '');
    }
    cleaned = cleaned.trim();

    return {
      'trackRef': trackRef?.group(0) ?? '',
      'alias': cleaned,
    };
  }

  @override
  String toString() =>
      'FindFilenameRegResponse(trackRef: $trackRef, alias: $alias, unwanted: $unwanted)';
}
