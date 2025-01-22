import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemon/settingsPage/presentation/widgets/groupedTile.dart';

import '../../common/data/providers/load_from_file.dart';
import '../bloc/settings_cubit.dart';
import 'InnerPages/info_page.dart';

/// This is settings page
///
/// [SettingPage] contains a title and several [GroupedTile]
/// wrapped by [Column]
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return ListView(
          children: [
            /// == Title ==
            SizedBox(
                height: 200,
                child: Center(
                    child: Text(
                  "settings",
                  style: Theme.of(context).textTheme.displaySmall,
                ))),

            /// == GroupedTile: information ==
            GroupedTile(children: [
              ListTile(
                title: Text("选择播放目录"),
                trailing: Text(state.audioPath),
                onTap: () => _handleChangeDir(context.read<SettingsCubit>()),
              ),
              ListTile(
                title: Text("重构索引"),
                trailing: Text(state.dbRebuiltTime?.split('.')[0] ?? "还没有重构过"),
                onTap: () =>
                    load(context.read<SettingsCubit>().state.audioPath),
              ),
            ]),

            /// == GroupedTile: Appearance ==
            SizedBox(
              height: 20,
            ),
            GroupedTile(children: [
              ListTile(
                title: Text("显示自带的专辑封面"),
                trailing: state.showCover ? Icon(Icons.check) : null,
                onTap: () => context.read<SettingsCubit>().changeShowCover(),
              ),
              ListTile(
                title: Text("清理文件名"),
                trailing: state.cleanFileName ? Icon(Icons.check) : null,
                onTap: () =>
                    context.read<SettingsCubit>().changeCleanFileName(),
              ),
              ListTile(
                title: Text("主题色"),
                trailing: Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    color: state.seedColor, // 使用传入的seedColor
                    shape: BoxShape.circle, // 圆形
                  ),
                ),
                onTap: () => context.read<SettingsCubit>().changeSeedColor(),
              ),
            ]),

            /// == GroupedTile: other ==
            SizedBox(
              height: 20,
            ),
            GroupedTile(children: [
              ListTile(
                title: Text("使用教程&作者"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InfoPage(),
                    ),
                  );
                },
              ),
            ]),
            SizedBox(
              height: 200,
            )
          ],
        );
      },
    );
  }
}

Future<void> _handleChangeDir(SettingsCubit settingsCubit) async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    settingsCubit.setPath(selectedDirectory);
    load(selectedDirectory);
  }
}
