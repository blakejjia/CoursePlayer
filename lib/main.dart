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

final jsonStoreProvider = Provider<MediaLibraryStore>((ref) {
  final settings = ref.watch(settingsProvider);
  return MediaLibraryStore(baseDirPath: settings.audioPath);
});
final albumRepositoryProvider = Provider<AlbumRepository>((ref) {
  final store = ref.watch(jsonStoreProvider);
  return AlbumRepository(store, ref: ref);
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Explicitly set a custom debug token for easier registration in the Firebase Console
  const appCheckDebugToken = '2224a8e2-9316-41c8-a293-47ddb69a313b';

  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider(debugToken: appCheckDebugToken)
        : const AndroidPlayIntegrityProvider(),
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
