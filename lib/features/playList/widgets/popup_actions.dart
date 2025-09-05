import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/playList/services/find_regex/presentation/popup.dart';
import 'package:lemon/features/playList/services/find_sequence/presentation/popup.dart';
import 'package:lemon/features/playList/providers/song_list_provider.dart';

class PopupMenu extends ConsumerWidget {
  const PopupMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songListProvider);
    final ready = state; // convenience alias to match songs_list_page.dart

    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'find_regex':
            if (ready.isReady) {
              showDialog(
                context: context,
                builder: (context) => FindRegexDialog(
                  album: ready.album!,
                ),
              );
            }
            break;
          case 'find_sequence':
            if (ready.isReady) {
              showDialog(
                context: context,
                builder: (context) => FindSequenceDialog(
                  album: ready.album!,
                ),
              );
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'find_regex',
            child: ListTile(
              leading: Icon(Icons.auto_fix_high),
              title: Text('Find Regex Pattern'),
              subtitle: Text('Auto-detect pattern to clean titles'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem<String>(
            value: 'find_sequence',
            child: ListTile(
              leading: Icon(Icons.sort),
              title: Text('Find Study Sequence'),
              subtitle: Text('Infer logical playback/study order'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ];
      },
    );
  }
}
