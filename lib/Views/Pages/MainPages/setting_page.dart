import 'package:course_player/Shared/Providers/SongProvider.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SongProvider songProvider = new SongProvider(); // cannot use getIt, don't know why
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: songProvider.loadSongFromDictionary, child: Text("重构索引")),
    );
  }
}