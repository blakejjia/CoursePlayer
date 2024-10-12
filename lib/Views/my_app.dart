import 'package:course_player/Shared/models/playlist.dart';
import 'package:course_player/Shared/providers/playlistProvider.dart';
import 'package:course_player/Views/features/ArtistPage/artist_page.dart';
import 'package:course_player/Views/features/CoursePage/course_page.dart';
import 'package:course_player/Views/features/HomePage/home_page.dart';
import 'package:course_player/Views/features/PermissionGrantPage.dart';
import 'package:course_player/Views/features/SettingPage/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final PlaylistsProvider _playlistsProvider = PlaylistsProvider();
  bool _isLoading = true;
  bool _isPermissionChecked = false; // 标记是否已经检查了权限
  bool _isPermissionGranted = true; // 默认认为权限已经授予，避免页面闪烁
  List<Playlist> _playlists = [];

  @override
  void initState() {
    super.initState();
    _checkPermissionInBackground(); // 后台检查权限
  }

  // 后台检查权限
  Future<void> _checkPermissionInBackground() async {
    // 确保主界面先显示出来，然后再异步检查权限
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        // 未授予权限
        setState(() {
          _isPermissionGranted = false;
        });
      } else {
        // 权限已授予，加载播放列表
        await _loadPlaylists();
      }
      setState(() {
        _isPermissionChecked = true; // 权限检查完成
      });
    });
  }

  // 请求权限，并在用户通过时更新UI
  Future<void> _requestPermission() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      setState(() {
        _isPermissionGranted = true;
        _isLoading = true; // 开始加载数据
      });
      _loadPlaylists(); // 加载播放列表
    }
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

    // 在权限未检查完毕之前，显示加载指示器
    if (!_isPermissionChecked) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading...")),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 如果权限没有被授予，则显示权限授予页面
    if (!_isPermissionGranted) {
      return PermissionGrantPage(onPermissionGranted: _requestPermission);
    }

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
