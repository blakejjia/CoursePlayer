import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lemon/core/audio/audio_service.dart';
import 'package:lemon/core/my_app.dart';
// Switch repositories to JSON-backed implementations
import 'package:lemon/core/backEnd/json/media_library_store.dart';
import 'package:lemon/core/backEnd/json/album_repository.dart' as json_repo;
import 'package:lemon/core/backEnd/json/song_repository.dart' as json_repo;
import 'package:lemon/core/backEnd/json/covers_repository.dart' as json_repo;
import 'package:lemon/features/settings/providers/settings_provider.dart';

// Riverpod providers to replace GetIt
// Swap DB for JSON MediaLibrary store
final jsonStoreProvider =
    Provider<MediaLibraryStore>((ref) => MediaLibraryStore());
final songRepositoryProvider = Provider<json_repo.SongRepository>(
    (ref) => json_repo.SongRepository(ref.read(jsonStoreProvider)));
final coversRepositoryProvider =
    Provider<json_repo.CoversRepository>((ref) => json_repo.CoversRepository());
final albumRepositoryProvider = Provider<json_repo.AlbumRepository>(
    (ref) => json_repo.AlbumRepository(ref.read(jsonStoreProvider)));
final audioHandlerProvider = FutureProvider<MyAudioHandler>((ref) async {
  final handler = await initAudioService();
  return handler;
});

// A global container only for legacy non-widget code paths that need access.
// Prefer passing WidgetRef where possible.
final providerContainer = ProviderContainer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: settings.seedColor,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => MyApp(),
      },
      initialRoute: "/",
    );
  }
}
