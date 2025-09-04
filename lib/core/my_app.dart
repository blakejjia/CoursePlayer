import 'package:flutter/material.dart';
import 'package:lemon/features/albums/album_page.dart';
import '../features/audioPage/audio_bottom_sheet.dart';
import '../features/settings/presentation/setting_page.dart';
import 'package:lemon/features/file_sys/widgets/loading_indicator.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      body: Stack(
        children: [
          pages[_currentIndex],
          const MediaLibraryLoadingIndicator(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AudioBottomSheet(),
          NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.album),
                label: "Courses",
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
