import 'package:course_player/Shared/DAO/dao.dart';
import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Shared/Providers/load_from_db.dart';
import 'package:course_player/Views/my_app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup(){
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<SongDAO>(SongDAO(getIt<AppDatabase>()));
  getIt.registerSingleton<CoversDao>(CoversDao(getIt<AppDatabase>()));
  getIt.registerSingleton<PlaylistsDao>(PlaylistsDao(getIt<AppDatabase>()));
  getIt.registerSingleton<LoadFromDb>(LoadFromDb());
}

void main() {
  setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const MyApp(),
      },
      initialRoute: "/",
    );
  }
}
