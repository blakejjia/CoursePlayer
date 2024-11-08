import 'package:course_player/data/providers/load_from_file.dart';
import 'package:course_player/logic/blocs/settings/settings_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () => pickDirectory(context.read<SettingsCubit>()),
              child: const Text("选择文件夹")),
          ElevatedButton(
              onPressed: () => load(context.read<SettingsCubit>().getPath()),
              child: const Text("重构索引")),
        ],
      ),
    );
  }
}

Future<void> pickDirectory(SettingsCubit settingsCubit) async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    settingsCubit.setPath(selectedDirectory);
    load(selectedDirectory);
  }
}
