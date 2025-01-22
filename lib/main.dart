import 'package:lemon/data/repositories/covers_repository.dart';
import 'package:lemon/data/repositories/playlist_repository.dart';
import 'package:lemon/data/models/models.dart';
import 'package:lemon/data/providers/load_from_db.dart';
import 'package:lemon/data/repositories/song_repository.dart';
import 'package:lemon/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:lemon/logic/blocs/playlist_page/playlist_page_cubit.dart';
import 'package:lemon/logic/blocs/settings/settings_cubit.dart';
import 'package:lemon/logic/services/audio_service.dart';
import 'package:lemon/presentation/screens/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'logic/blocs/album_page/album_page_bloc.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // hydrated bloc
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // getIt
  getIt.registerSingleton<SettingsCubit>(SettingsCubit());
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<SongRepository>(SongRepository(getIt<AppDatabase>()));
  getIt.registerSingleton<CoversRepository>(
      CoversRepository(getIt<AppDatabase>()));
  getIt.registerSingleton<PlaylistRepository>(
      PlaylistRepository(getIt<AppDatabase>()));
  getIt.registerSingleton<LoadFromDb>(LoadFromDb());
  getIt.registerSingleton<MyAudioHandler>(await initAudioService());
}

void main() async {
  await setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(create: (_) => getIt<SettingsCubit>()),
        BlocProvider<AudioPlayerBloc>(create: (_) => AudioPlayerBloc()),
        BlocProvider<AlbumPageBloc>(create: (_) => AlbumPageBloc()),
        BlocProvider<PlaylistPageCubit>(create: (_) => PlaylistPageCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) => prev.seedColor != curr.seedColor,
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              colorSchemeSeed: Color(state.seedColor),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            routes: {
              "/": (context) => const MyApp(),
            },
            initialRoute: "/",
          );
        },
      ),
    );
  }
}
