import 'package:course_player/Views/features/ArtistPage/ArtistPage.dart';
import 'package:course_player/Views/features/CoursePage/CoursePage.dart';
import 'package:course_player/Views/features/HomePage/HomePage.dart';
import 'package:course_player/Views/features/SettingPage/SettingPage.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const CoursePage(),
    const ArtistPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("courser"),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.album), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Artists"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        iconSize: 25,
        fixedColor: Theme.of(context).colorScheme.primary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
