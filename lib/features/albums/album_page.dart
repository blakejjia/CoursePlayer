import 'package:flutter/material.dart';
import 'package:lemon/features/albums/widgets/albums_view.dart';
import 'package:lemon/features/albums/views/loading_view.dart';
import 'package:lemon/features/albums/views/no_permission_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'providers/album_provider.dart';

part 'views/blank_view.dart';

// Helper to access settings provider from parts
Future<void> chooseAudioRootDir(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  await container.read(settingsProvider.notifier).updatePath();
}

class AlbumPage extends ConsumerWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(albumsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courser'),
        leading: IconButton(
          icon: Icon(Icons.play_circle_filled),
          onPressed: () {
            if (state.lastPlayedAlbumId != null) {
              ref
                  .read(albumsProvider.notifier)
                  .playAlbumById(state.lastPlayedAlbumId!);
            }
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (_) => ref.read(albumsProvider.notifier).toggleView(),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                    value: 'ListView',
                    child: Text(state.isGridView ? 'list view' : 'grid view')),
              ];
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(albumsProvider.notifier).load(),
        child: state.isLoading
            ? const LoadingView()
            : (state.albums.isEmpty
                ? const BlankView()
                : AlbumsView(
                    isGridView: state.isGridView,
                    albums: state.albums,
                    info: state.info ?? {},
                  )),
      ),
    );
  }
}
