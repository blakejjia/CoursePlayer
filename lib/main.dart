import 'package:course_player/Shared/DAO/models.dart';
import 'package:course_player/Views/my_app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import './Shared/providers/SongProvider.dart';

final getIt = GetIt.instance;

void setup(){
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<SongProvider>(SongProvider());
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
