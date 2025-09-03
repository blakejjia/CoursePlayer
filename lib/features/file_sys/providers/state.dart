class MediaLibraryState {
  final bool isRebuilding;
  final int currentFolder;
  final int totalFolder;
  final int currentFile;
  final int totalFile;
  final String? error;

  const MediaLibraryState({
    required this.isRebuilding,
    required this.currentFolder,
    required this.totalFolder,
    required this.currentFile,
    required this.totalFile,
    this.error,
  });

  factory MediaLibraryState.initial() => const MediaLibraryState(
        isRebuilding: false,
        currentFolder: 0,
        totalFolder: 0,
        currentFile: 0,
        totalFile: 0,
        error: null,
      );

  MediaLibraryState copyWith({
    bool? isRebuilding,
    int? currentFolder,
    int? totalFolder,
    int? currentFile,
    int? totalFile,
    String? error,
  }) {
    return MediaLibraryState(
      isRebuilding: isRebuilding ?? this.isRebuilding,
      currentFolder: currentFolder ?? this.currentFolder,
      totalFolder: totalFolder ?? this.totalFolder,
      currentFile: currentFile ?? this.currentFile,
      totalFile: totalFile ?? this.totalFile,
      error: error,
    );
  }
}
