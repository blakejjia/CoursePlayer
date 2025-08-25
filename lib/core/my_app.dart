import 'package:flutter/material.dart';
import '../features/album/album_page.dart';
import 'audio/audio_bottom_sheet.dart';
import '../features/settings/presentation/setting_page.dart';

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const AlbumPage(),
      const SettingPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AudioBottomSheet(),
          BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.album), label: "Courses"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Settings"),
            ],
            iconSize: 25,
            fixedColor: Theme.of(context).colorScheme.primary,
            type: BottomNavigationBarType.fixed,
          ),
        ],
      ),
    );
  }
}
