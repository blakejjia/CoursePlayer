import 'package:course_player/data/repositories/covers_repository.dart';
import 'package:course_player/data/repositories/playlist_repository.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/providers/load_from_db.dart';
import 'package:course_player/data/repositories/song_repository.dart';
import 'package:course_player/logic/blocs/audio_info/audio_info_bloc.dart';
import 'package:course_player/logic/blocs/audio_player/audio_player_bloc.dart';
import 'package:course_player/logic/blocs/settings/settings_cubit.dart';
import 'package:course_player/logic/services/audio_service.dart';
import 'package:course_player/presentation/screens/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

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
        BlocProvider<SettingsCubit>(create: (_) => SettingsCubit()),
        BlocProvider<AudioPlayerBloc>(create: (_) => AudioPlayerBloc()),
        BlocProvider<AudioInfoBloc>(create: (_) => AudioInfoBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => const MyApp(),
        },
        initialRoute: "/",
      ),
    );
  }
}
