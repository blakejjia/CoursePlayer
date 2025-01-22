import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/data/providers/load_from_file.dart';
import '../bloc/settings_cubit.dart';
import 'info_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              // ====================================
              SizedBox(
                  height: 200,
                  child: Center(
                      child: Text(
                    "settings",
                    style: Theme.of(context).textTheme.displaySmall,
                  ))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white, // 背景颜色
                  borderRadius: BorderRadius.circular(12), // 圆角半径
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("选择播放目录"),
                      trailing: Text(state.audioPath),
                      onTap: () => pickDirectory(context.read<SettingsCubit>()),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("重构索引"),
                      trailing:
                          Text(state.dbRebuiltTime?.split('.')[0] ?? "还没有重构过"),
                      onTap: () =>
                          load(context.read<SettingsCubit>().state.audioPath),
                    ),
                  ],
                ),
              ),
              // =======================================
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white, // 背景颜色
                  borderRadius: BorderRadius.circular(12), // 圆角半径
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("显示自带的专辑封面"),
                      trailing: state.showCover ? Icon(Icons.check) : null,
                      onTap: () =>
                          context.read<SettingsCubit>().changeShowCover(),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("清理文件名"),
                      trailing: state.cleanFileName ? Icon(Icons.check) : null,
                      onTap: () =>
                          context.read<SettingsCubit>().changeCleanFileName(),
                    ),
                    Divider(),
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
                      onTap: () =>
                          context.read<SettingsCubit>().changeSeedColor(),
                    ),
                  ],
                ),
              ),

              // =========================================
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white, // 背景颜色
                  borderRadius: BorderRadius.circular(12), // 圆角半径
                ),
                child: Column(
                  children: [
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
                  ],
                ),
              ),
              SizedBox(
                height: 200,
              )
            ],
          );
        },
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
