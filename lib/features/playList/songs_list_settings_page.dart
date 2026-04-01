import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/main.dart';
import 'package:lemon/features/playList/providers/song_list_provider.dart';

class SongsListSettingsPage extends ConsumerWidget {
  const SongsListSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songListProvider);
    final ready = state; // convenience alias to match songs_list_page.dart

    return Scaffold(
      appBar: AppBar(
        title: const Text('播放列表设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('根据文件创建时间排序'),
            onTap: () {
              if (ready.isReady) {
                final albumId = ready.album!.id;
                ref
                    .read(albumRepositoryProvider)
                    .sortAlbumSongs(albumId, 'creation_time')
                    .then((_) {
                  ref.read(songListProvider.notifier).refreshSongs();
                });
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.sort_by_alpha),
            title: const Text('根据文件名排序'),
            onTap: () {
              if (ready.isReady) {
                final albumId = ready.album!.id;
                ref
                    .read(albumRepositoryProvider)
                    .sortAlbumSongs(albumId, 'name')
                    .then((_) {
                  ref.read(songListProvider.notifier).refreshSongs();
                });
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            trailing: ready.album?.isAiSorted == true
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            title: const Text('AI 辅助排序'),
            subtitle: Text(ready.album?.isAiSorted == true
                ? '已完成 AI 智能排序'
                : '根据文件名智能识别排序'),
            onTap: () async {
              if (ready.isReady) {
                final album = ready.album!;
                final albumId = album.id;

                if (album.isAiSorted == true) {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('确认重新排序'),
                          content: const Text('该列表已经是 AI 排序过的，是否确认再次重排？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('确认'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                  if (!confirm) return;
                }

                // Show loading indicator
                if (context.mounted) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                }

                try {
                  final aiService = ref.read(aiSortServiceProvider);
                  final ranks = await aiService.generateAiRanks(album.songs);

                  await ref
                      .read(albumRepositoryProvider)
                      .updateSongsAiRank(albumId, ranks);
                  await ref
                      .read(albumRepositoryProvider)
                      .sortAlbumSongs(albumId, 'ai_rank');
                  await ref.read(songListProvider.notifier).refreshSongs();

                  if (context.mounted) {
                    Navigator.of(context).pop(); // dismiss loading
                    Navigator.of(context).pop(); // back to playlist
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop(); // dismiss loading
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('AI 排序失败: $e')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
