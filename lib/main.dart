import 'package:lemon/core/backEnd/data/models/models.dart';
import 'package:lemon/core/backEnd/data/repositories/song_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lemon/core/audio/audio_service.dart';
import 'package:lemon/core/my_app.dart';
// import 'package:lemon/features/album/bloc/album_page_cubit.dart';
// migrated: playlist now uses Riverpod providers
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'core/backEnd/data/repositories/covers_repository.dart';
import 'core/backEnd/data/repositories/album_repository.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // hydrated bloc
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // getIt
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<SongRepository>(SongRepository(getIt<AppDatabase>()));
  getIt.registerSingleton<CoversRepository>(
      CoversRepository(getIt<AppDatabase>()));
  getIt.registerSingleton<AlbumRepository>(
      AlbumRepository(getIt<AppDatabase>()));
  // Global ProviderContainer for non-widget access to providers
  getIt.registerSingleton<ProviderContainer>(ProviderContainer());
  // Album page now uses Riverpod, no Bloc singleton needed.
  getIt.registerSingleton<MyAudioHandler>(await initAudioService());
}

void main() async {
  await setup();
  runApp(ProviderScope(
      parent: getIt<ProviderContainer>(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
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
      },
    );
  }
}
