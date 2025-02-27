import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemon/settingsPage/presentation/widgets/grouped_tile.dart';

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
                title: Text("select dictionary"),
                trailing: Text(state.audioPath),
                onTap: () => _handleChangeDir(context.read<SettingsCubit>()),
              ),
              ListTile(
                title: Text("rebuild index"),
                trailing: Text(state.dbRebuiltTime?.split('.')[0] ?? "not yet built"),
                onTap: () =>
                    rebuildDb(context.read<SettingsCubit>().state.audioPath),
              ),
            ]),

            /// == GroupedTile: Appearance ==
            SizedBox(
              height: 20,
            ),
            GroupedTile(children: [
              ListTile(
                title: Text("show album cover"),
                trailing: state.showCover ? Icon(Icons.check) : null,
                onTap: () => context.read<SettingsCubit>().changeShowCover(),
              ),
              ListTile(
                title: Text("clean up file name"),
                trailing: state.cleanFileName ? Icon(Icons.check) : null,
                onTap: () =>
                    context.read<SettingsCubit>().changeCleanFileName(),
              ),
              ListTile(
                title: Text("theme color"),
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
                title: Text("tutorial& author"),
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
    rebuildDb(selectedDirectory);
  }
}
