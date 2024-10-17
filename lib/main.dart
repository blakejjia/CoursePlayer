import 'package:course_player/Views/my_app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import './Shared/providers/playlistProvider.dart';

final getIt = GetIt.instance;

void setup(){
  getIt.registerSingleton<PlaylistsProvider>(PlaylistsProvider());
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
