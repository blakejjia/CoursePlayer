import 'package:course_player/presentation/screens/pages/playlist_page.dart';
import 'package:course_player/presentation/screens/pages/setting_page.dart';
import 'package:course_player/presentation/widgets/audio_bottom_sheet.dart';
import 'package:course_player/presentation/screens/oneTime/permission_grant_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  bool _isPermissionGranted = false;

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
        setState(() {
          _isPermissionGranted = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 如果权限没有被授予，则显示权限授予页面
    if (!_isPermissionGranted) {
      return PermissionGrantPage(
          onPermissionGranted: _checkPermissionInBackground);
    }

    final List<Widget> pages = [
      const CoursePage(),
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
