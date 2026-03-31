import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/data/repositories/album_repository.dart';

// Switch repositories to JSON-backed implementations
import 'package:lemon/core/data/repositories/storage.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:lemon/core/router/app_router.dart';
import 'package:lemon/core/services/media_library_file_watcher.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

final jsonStoreProvider =
    Provider<MediaLibraryStore>((ref) => MediaLibraryStore());
final albumRepositoryProvider = Provider<AlbumRepository>(
    (ref) => AlbumRepository(ref.read(jsonStoreProvider), ref: ref));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode ? const AndroidDebugProvider() : const AndroidPlayIntegrityProvider(),
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(goRouterProvider);

    ref.watch(mediaLibraryFileWatcherProvider);

    return MaterialApp.router(
      theme: ThemeData(
        colorSchemeSeed: settings.seedColor,
        useMaterial3: true,
        sliderTheme: const SliderThemeData(),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
