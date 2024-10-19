import 'package:course_player/Shared/Providers/load_from_file.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: loadFromFile().load, child: const Text("重构索引")),
    );
  }
}