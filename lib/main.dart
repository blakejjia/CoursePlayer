import 'package:lemon/backEnd/data/models/models.dart';
import 'package:lemon/backEnd/data/repositories/song_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lemon/core/my_app.dart';
import 'package:path_provider/path_provider.dart';
import 'backEnd/data/repositories/covers_repository.dart';
import 'backEnd/data/repositories/album_repository.dart';

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

  getIt.registerSingleton<SettingsCubit>(SettingsCubit());
  getIt.registerSingleton<SongListPageBloc>(SongListPageBloc());
  getIt.registerSingleton<AlbumPageCubit>(AlbumPageCubit());
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
        BlocProvider<SongListPageBloc>(
            create: (_) => getIt<SongListPageBloc>()),
        BlocProvider<AlbumPageCubit>(create: (_) => getIt<AlbumPageCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) => prev.seedColor != curr.seedColor,
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              colorSchemeSeed: state.seedColor,
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            routes: {
              "/": (context) => MyApp(),
            },
            initialRoute: "/",
          );
        },
      ),
    );
  }
}
