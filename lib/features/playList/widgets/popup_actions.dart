import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/main.dart';
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
          case 'sort_by_creation_time':
            if (ready.isReady) {
              final albumId = ready.album!.id;
              ref.read(albumRepositoryProvider).sortAlbumSongs(albumId, 'creation_time').then((_) {
                 ref.read(songListProvider.notifier).refreshSongs();
              });
            }
            break;
          case 'sort_by_name':
            if (ready.isReady) {
              final albumId = ready.album!.id;
              ref.read(albumRepositoryProvider).sortAlbumSongs(albumId, 'name').then((_) {
                 ref.read(songListProvider.notifier).refreshSongs();
              });
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'sort_by_creation_time',
            child: ListTile(
              leading: Icon(Icons.access_time),
              title: Text('根据文件创建时间排序'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem<String>(
            value: 'sort_by_name',
            child: ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: Text('根据文件名排序'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ];
      },
    );
  }
}
