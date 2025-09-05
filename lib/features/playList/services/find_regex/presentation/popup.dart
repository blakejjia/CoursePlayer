import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:lemon/features/playList/services/find_regex/find_regex.dart';
import 'package:lemon/features/playList/services/find_regex/models.dart';

/// Dialog for finding regex patterns to clean up song titles
class FindRegexDialog extends ConsumerStatefulWidget {
  final Album album;

  const FindRegexDialog({
    super.key,
    required this.album,
  });

  @override
  ConsumerState<FindRegexDialog> createState() => _FindRegexDialogState();
}

class _FindRegexDialogState extends ConsumerState<FindRegexDialog> {
  @override
  Widget build(BuildContext context) {
    final findRegexState = ref.watch(findRegexServiceProvider);

    return AlertDialog(
      title: const Text('Find Regex Pattern'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show sample file names
            Text(
              'Sample files:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.album.songs
                    .take(5)
                    .map((song) => Text(
                          song.title,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Show current state
            findRegexState.when(
              data: (response) => _buildSuccessView(context, response),
              loading: () => _buildLoadingView(),
              error: (error, _) => _buildErrorView(context, error),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          onPressed: findRegexState.isLoading
              ? null
              : () => _findRegexPattern(widget.album),
          child: findRegexState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Find Pattern'),
        ),
        if (findRegexState.value != null)
          OutlinedButton(
            onPressed: () => _applyRegexPattern(findRegexState.value!),
            child: const Text('Apply Pattern'),
          ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return const Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 12),
        Text('Analyzing file patterns...'),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, Object error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Error: ${error.toString()}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(
      BuildContext context, FindFilenameRegResponse? response) {
    if (response == null) {
      return const Text('Click "Find Pattern" to analyze your files.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show test results
        Text(
          'Pattern Test Results:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...widget.album.songs.take(3).map((song) {
          final testResult = response.applyPattern(song.title);
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  testResult != null ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: testResult != null ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    testResult != null
                        ? '${song.title} → "${testResult['trackRef']}" + "${testResult['alias']}"'
                        : '${song.title} → No match',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _findRegexPattern(Album album) {
    ref.read(findRegexServiceProvider).findAlbumRegex(album);
  }

  void _applyRegexPattern(FindFilenameRegResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pattern applied! Regex: ${response.toString()}'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }
}
