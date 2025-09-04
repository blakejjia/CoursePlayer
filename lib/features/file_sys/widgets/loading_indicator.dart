import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/file_sys/providers/filesys_provider.dart';

/// Small overlay that listens to the media library provider and shows
/// rebuild progress / errors. Designed to be inserted into a Stack so it
/// can appear above app content.
class MediaLibraryLoadingIndicator extends ConsumerWidget {
  const MediaLibraryLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(mediaLibraryProvider);

    return async.when(
      data: (state) {
        // Nothing to show when not rebuilding and no error.
        if (!state.isRebuilding && state.error == null)
          return const SizedBox.shrink();

        final theme = Theme.of(context);

        Widget content;
        if (state.isRebuilding) {
          // Compute a simple progress value if we have totals, otherwise indeterminate.
          double? progress;
          if (state.totalFile > 0) {
            progress = state.currentFile / state.totalFile;
            if (progress < 0 || progress > 1) progress = null;
          } else if (state.totalFolder > 0) {
            progress = state.currentFolder / state.totalFolder;
            if (progress < 0 || progress > 1) progress = null;
          }

          content = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rebuilding media library',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Folders ${state.currentFolder}/${state.totalFolder} • Files ${state.currentFile}/${state.totalFile}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Progress bar
              SizedBox(
                height: 4,
                child: progress == null
                    ? const LinearProgressIndicator()
                    : LinearProgressIndicator(value: progress),
              ),
            ],
          );
        } else {
          // show error banner
          content = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Media library error: ${state.error}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onError),
                  ),
                ),
              ],
            ),
          );
        }

        // Positioned container for overlay. The parent should be a Stack.
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Material(
            elevation: 4,
            color: state.isRebuilding
                ? theme.colorScheme.surface
                : theme.colorScheme.error,
            child: SafeArea(child: content),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, st) {
        // Show the error as a small banner
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Material(
            elevation: 4,
            color: Theme.of(context).colorScheme.error,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text('Media library error: $err',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onError))),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
