import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Switch repositories to JSON-backed implementations
import 'package:lemon/core/data/utils/media_library_store.dart';
import 'package:lemon/core/data/repositories/album_repository.dart'
    as json_repo;
import 'package:lemon/core/data/repositories/song_repository.dart' as json_repo;
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:lemon/core/router/app_router.dart';
import 'package:lemon/core/services/app_lifecycle_service.dart';
import 'package:lemon/core/services/media_library_file_watcher.dart';

final jsonStoreProvider =
    Provider<MediaLibraryStore>((ref) => MediaLibraryStore());
final songRepositoryProvider = Provider<json_repo.SongRepository>(
    (ref) => json_repo.SongRepository(ref.read(jsonStoreProvider), ref: ref));
final albumRepositoryProvider = Provider<json_repo.AlbumRepository>(
    (ref) => json_repo.AlbumRepository(ref.read(jsonStoreProvider), ref: ref));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(goRouterProvider);

    // Initialize app lifecycle service to handle progress saving
    ref.watch(appLifecycleServiceProvider);

    // Initialize file watcher to automatically reload data when JSON changes
    ref.watch(mediaLibraryFileWatcherProvider);

    return MaterialApp.router(
      theme: ThemeData(
        colorSchemeSeed: settings.seedColor,
        useMaterial3: true,
        sliderTheme: const SliderThemeData(year2023: false),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
