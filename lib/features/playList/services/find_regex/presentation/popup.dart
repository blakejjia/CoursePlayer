import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:lemon/features/playList/services/find_regex/find_regex.dart';
import 'package:lemon/features/playList/services/find_regex/models.dart';

/// Dialog for finding regex patterns to clean up song titles
class FindRegexDialog extends ConsumerStatefulWidget {
  final Album album;
  final List<Song> songs;

  const FindRegexDialog({
    super.key,
    required this.album,
    required this.songs,
  });

  @override
  ConsumerState<FindRegexDialog> createState() => _FindRegexDialogState();
}

class _FindRegexDialogState extends ConsumerState<FindRegexDialog> {
  @override
  Widget build(BuildContext context) {
    final findRegexState = ref.watch(findRegexProvider);

    return AlertDialog(
      title: const Text('Find Regex Pattern'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analyze ${widget.songs.length} songs in "${widget.album.title}" to find a regex pattern that can split filenames into sequence numbers and clean titles.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

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
                children: widget.songs
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
        ElevatedButton(
          onPressed:
              findRegexState.isLoading ? null : () => _findRegexPattern(),
          child: findRegexState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Find Pattern'),
        ),
        if (findRegexState.value != null)
          ElevatedButton(
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
        Text(
          'Found Pattern:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            response.regExp,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ),
        const SizedBox(height: 12),

        // Show test results
        Text(
          'Pattern Test Results:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...widget.songs.take(3).map((song) {
          final testResult = response.testPattern(song.title);
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
                        ? '${song.title} → "${testResult['sequence']}" + "${testResult['title']}"'
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

  void _findRegexPattern() {
    final fileNames = widget.songs.map((song) => song.title).toList();
    ref.read(findRegexProvider.notifier).findRegexFromFiles(fileNames);
  }

  void _applyRegexPattern(FindFilenameRegResponse response) {
    // TODO: Implement applying the regex pattern to clean up song titles
    // This would involve updating the song database with cleaned titles
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pattern applied! Regex: ${response.regExp}'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }
}
