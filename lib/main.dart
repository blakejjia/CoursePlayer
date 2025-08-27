import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lemon/core/audio/audio_service.dart';
import 'package:lemon/core/backEnd/data/models/models.dart';
import 'package:lemon/core/backEnd/data/repositories/album_repository.dart';
import 'package:lemon/core/backEnd/data/repositories/covers_repository.dart';
import 'package:lemon/core/backEnd/data/repositories/song_repository.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:lemon/core/router/app_router.dart';

// Riverpod providers to replace GetIt
final dbProvider = Provider<AppDatabase>((ref) => AppDatabase());
final songRepositoryProvider =
    Provider<SongRepository>((ref) => SongRepository(ref.read(dbProvider)));
final coversRepositoryProvider =
    Provider<CoversRepository>((ref) => CoversRepository(ref.read(dbProvider)));
final albumRepositoryProvider =
    Provider<AlbumRepository>((ref) => AlbumRepository(ref.read(dbProvider)));
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
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      theme: ThemeData(
        colorSchemeSeed: settings.seedColor,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
