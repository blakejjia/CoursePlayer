import 'package:course_player/data/repositories/covers_repository.dart';
import 'package:course_player/data/repositories/playlist_repository.dart';
import 'package:course_player/data/models/models.dart';
import 'package:course_player/data/repositories/song_repository.dart';
import 'package:course_player/logic/blocs/playlist_page/playlist_page_cubit.dart';
import 'package:course_player/logic/blocs/settings/settings_cubit.dart';
import 'package:course_player/logic/services/audio_service.dart';
import 'package:course_player/presentation/screens/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'data/providers/load_from_db.dart';
import 'logic/blocs/album_page/album_page_bloc.dart';
import 'logic/blocs/audio_player/audio_player_bloc.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Ensure that the widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // Initialize Hive and open boxes
  await Hive.initFlutter(); // Initialize Hive (only once in the app)

  // Open Hive boxes before passing them into repositories
  Hive.registerAdapter(CoverAdapter());
  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(PlaylistAdapter());
  var songBox = await Hive.openBox<Song>('songs');
  var coverBox = await Hive.openBox<Cover>('covers');
  var playlistBox = await Hive.openBox<Playlist>('playlists');

  // Initialize GetIt for dependency injection
  getIt.registerSingleton<SettingsCubit>(SettingsCubit());
  getIt.registerSingleton<SongRepository>(SongRepository(songBox));
  getIt.registerSingleton<CoversRepository>(CoversRepository(coverBox)); // Pass coverBox to CoversRepository
  getIt.registerSingleton<PlaylistRepository>(PlaylistRepository(playlistBox)); // Pass playlistBox to PlaylistRepository

  getIt.registerSingleton<LoadFromDb>(LoadFromDb());

  // Initialize and register audio handler
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
