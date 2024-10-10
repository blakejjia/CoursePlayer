import 'package:course_player/Shared/models/playlist.dart';
import 'package:course_player/Shared/providers/playlistProvider.dart';
import 'package:course_player/Views/features/ArtistPage/artist_page.dart';
import 'package:course_player/Views/features/CoursePage/course_page.dart';
import 'package:course_player/Views/features/HomePage/home_page.dart';
import 'package:course_player/Views/features/SettingPage/setting_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PlaylistsProvider _playlistsProvider = PlaylistsProvider();
  bool _isLoading = true;
  List<Playlist> _playlists = [];

@override
void initState() {
  super.initState();
  _loadPlaylists();
}

  // 调用 loadPlaylists() 并更新 UI
  Future<void> _loadPlaylists() async {
    try {
      await _playlistsProvider.loadPlaylists();
      setState(() {
        _playlists = _playlistsProvider.playlists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading playlists: $e');
    }
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _isLoading // 检查是否在加载
          ? const Center(child: CircularProgressIndicator()) // 显示加载指示器
          : HomePage(playlists: _playlists), // 将 playlists 作为参数传递
      const CoursePage(),
      const ArtistPage(),
      const SettingPage(),
    ];

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
