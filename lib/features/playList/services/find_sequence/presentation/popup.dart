import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/data/models/models.dart';
import 'package:lemon/features/playList/services/find_sequence/find_sequence.dart';
import 'package:lemon/features/playList/services/find_sequence/models.dart';

/// Dialog for finding logical sequence/study order for course files
class FindSequenceDialog extends ConsumerStatefulWidget {
  final Album album;
  const FindSequenceDialog({
    super.key,
    required this.album,
  });

  @override
  ConsumerState<FindSequenceDialog> createState() => _FindSequenceDialogState();
}

class _FindSequenceDialogState extends ConsumerState<FindSequenceDialog> {
  @override
  Widget build(BuildContext context) {
    final findSequenceState = ref.watch(findSequenceProvider);

    return AlertDialog(
      title: const Text('Find Study Sequence'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analyze ${widget.album.songs.length} files in "${widget.album.title}" to infer a logical playback/study order and group adjacent files into segments.',
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
            findSequenceState.when(
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
          onPressed: findSequenceState.isLoading ? null : () => _findSequence(),
          child: findSequenceState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Find Sequence'),
        ),
        if (findSequenceState.value != null)
          ElevatedButton(
            onPressed: () => _applySequence(findSequenceState.value!),
            child: const Text('Apply Sequence'),
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
        Text('Analyzing course structure...'),
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
      BuildContext context, FindSequenceResponse? response) {
    if (response == null) {
      return const Text('Click "Find Sequence" to analyze your course files.');
    }

    final segmentInfo = response.getSegmentInfo();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Found Sequence (${segmentInfo.length} segments):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),

        // Show segments
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: segmentInfo.map((segment) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.folder_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              segment['name'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const Spacer(),
                            Chip(
                              label: Text('${segment['count']} files'),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...((segment['files'] as List<String>).take(3).map(
                              (file) => Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, bottom: 2),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.play_circle_outline,
                                      size: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        file,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontFamily: 'monospace',
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        if ((segment['files'] as List<String>).length > 3)
                          Padding(
                            padding: const EdgeInsets.only(left: 24, top: 4),
                            child: Text(
                              '... and ${(segment['files'] as List<String>).length - 3} more files',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Summary
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Total: ${response.getAllFilenames().length} files organized into ${segmentInfo.length} logical segments',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _findSequence() {
    final notifier = ref.read(findSequenceProvider.notifier);

    // Convert songs to the format expected by the service
    final songsData = widget.album.songs
        .map((song) => {
              'title': song.title,
              'path': song.path,
            })
        .toList();

    notifier.findSequenceFromCurrentAlbum(songsData);
  }

  void _applySequence(FindSequenceResponse response) {
    // TODO: Implement sequence application logic
    // This would typically:
    // 1. Reorder the playlist according to the sequence
    // 2. Update the UI to show the new order
    // 3. Optionally save the sequence for future use

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sequence with ${response.getSegmentNames().length} segments would be applied (implementation pending)',
        ),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}
