import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/main.dart';
import 'package:lemon/features/playList/providers/song_list_provider.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:lemon/core/data/models/models.dart';

class SongsListSettingsPage extends ConsumerWidget {
  const SongsListSettingsPage({super.key});

  void _handleSort(BuildContext context, WidgetRef ref, String albumId, String sortField) {
    ref.read(albumRepositoryProvider).sortAlbumSongs(albumId, sortField).then((_) {
      ref.read(songListProvider.notifier).refreshSongs();
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(songListProvider);

    if (!state.isReady) {
      return Scaffold(
        appBar: AppBar(title: const Text('播放列表设置')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final album = state.album!;
    final albumId = album.id;
    final isAiSorted = album.isAiSorted == true;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('播放列表设置', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.3),
              colorScheme.surface,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Display info about the album
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.title,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '包含 ${album.songs.length} 首曲目',
                      style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),

              const _SectionTitle(title: '排序方式 (3选1)'),
              Card(
                elevation: 0,
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
                ),
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    _SortOptionTile(
                      icon: Icons.access_time_rounded,
                      title: '按文件创建时间',
                      subtitle: '较早添加的文件排在前面',
                      onTap: () => _handleSort(context, ref, albumId, 'creation_time'),
                    ),
                    Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
                    _SortOptionTile(
                      icon: Icons.sort_by_alpha_rounded,
                      title: '按文件名',
                      subtitle: '按照名称字母顺序升序',
                      onTap: () => _handleSort(context, ref, albumId, 'name'),
                    ),
                    Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
                    _SortOptionTile(
                      icon: Icons.auto_awesome,
                      title: '按 AI 智能排序',
                      subtitle: isAiSorted ? '应用已获取的 AI 排序' : '当前未获取 AI 排序数据',
                      iconColor: isAiSorted ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                      onTap: () {
                        if (!isAiSorted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('请先执行下方的"获取 AI 排序分析"')),
                          );
                          return;
                        }
                        _handleSort(context, ref, albumId, 'ai_rank');
                      },
                    ),
                  ],
                ),
              ),

              const _SectionTitle(title: 'AI 功能选项'),
              Card(
                elevation: 0,
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
                ),
                margin: const EdgeInsets.only(bottom: 32),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.title, color: colorScheme.onSecondaryContainer),
                  ),
                  title: const Text('使用 AI 优化后的标题', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('在列表中显示智能识别的集数和标题'),
                  value: ref.watch(settingsProvider).useAiTitle,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).changeUseAiTitle();
                  },
                ),
              ),

              // Separate button for AI Generating
              FilledButton.icon(
                onPressed: () => _handleGenerateAiSort(context, ref, album),
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('获取 AI 排序分析', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: isAiSorted ? colorScheme.secondaryContainer : colorScheme.primary,
                  foregroundColor: isAiSorted ? colorScheme.onSecondaryContainer : colorScheme.onPrimary,
                  elevation: isAiSorted ? 0 : 2,
                ),
              ),
              if (isAiSorted)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green.shade600),
                      const SizedBox(width: 4),
                      Text('此列表已完成分析', style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGenerateAiSort(BuildContext context, WidgetRef ref, Album album) async {
    if (album.isAiSorted == true) {
      final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
              title: const Text('重复操作确认', textAlign: TextAlign.center),
              content: const Text(
                '该列表已经成功经过 AI 分析。\n\n再次分析将消耗额度，且结果大概率相同。为了避免浪费，强烈建议不要再次生成。\n\n是否确认继续？',
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('取消 (推荐)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('强制继续', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ) ??
          false;
      if (!confirm) return;
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('AI 正在分析中...', style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final aiService = ref.read(aiSortServiceProvider);
      final metadata = await aiService.generateAiMetadata(album.songs);

      await ref.read(albumRepositoryProvider).updateSongsAiMetadata(album.id, metadata);
      await ref.read(albumRepositoryProvider).sortAlbumSongs(album.id, 'ai_rank');
      await ref.read(songListProvider.notifier).refreshSongs();
      await ref.read(settingsProvider.notifier).setUseAiTitle(true);

      if (context.mounted) {
        Navigator.of(context).pop(); // dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI 分析与排序已完成并应用！')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // dismiss loading
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('分析失败'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback onTap;

  const _SortOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.6))),
      trailing: Icon(Icons.chevron_right, size: 20, color: colorScheme.onSurface.withValues(alpha: 0.4)),
      onTap: onTap,
    );
  }
}
