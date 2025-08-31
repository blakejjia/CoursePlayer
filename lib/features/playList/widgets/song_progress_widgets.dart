import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/audio/providers/porgress/progress_update_provider.dart';
import 'package:lemon/core/data/json/models/models.dart';

/// A widget that displays real-time progress for a song
/// This automatically updates when progress changes without requiring full reloads
class SongProgressIndicator extends ConsumerWidget {
  final Song song;
  final bool showPercentage;
  final TextStyle? textStyle;

  const SongProgressIndicator({
    super.key,
    required this.song,
    this.showPercentage = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for progress updates
    ref.watch(currentSongProgressProvider);

    // Get the current progress for this song
    final currentProgress =
        ref.read(currentSongProgressProvider.notifier).getProgress(song.id);

    // Use the real-time progress if available, otherwise fall back to stored progress
    final progress =
        currentProgress > 0 ? currentProgress : song.playedInSecond;

    if (song.length <= 0 || progress <= 0) {
      return const SizedBox.shrink();
    }

    final percentage = (progress / song.length * 100).round();

    if (!showPercentage) {
      return LinearProgressIndicator(
        value: progress / song.length,
        backgroundColor: Colors.grey.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return Text(
      '$percentage%',
      style: textStyle ??
          Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
    );
  }
}

/// A widget that shows formatted time progress
class SongTimeProgress extends ConsumerWidget {
  final Song song;
  final TextStyle? textStyle;

  const SongTimeProgress({
    super.key,
    required this.song,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for progress updates
    ref.watch(currentSongProgressProvider);

    // Get the current progress for this song
    final currentProgress =
        ref.read(currentSongProgressProvider.notifier).getProgress(song.id);

    // Use the real-time progress if available, otherwise fall back to stored progress
    final progress =
        currentProgress > 0 ? currentProgress : song.playedInSecond;

    if (progress <= 0) {
      return const SizedBox.shrink();
    }

    return Text(
      _formatDuration(progress),
      style: textStyle ??
          Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }
}
