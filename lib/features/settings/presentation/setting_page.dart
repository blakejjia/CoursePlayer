import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/settings/presentation/widgets/grouped_tile.dart';
import 'package:lemon/features/settings/presentation/widgets/speedSelectionBS.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'InnerPages/info_page.dart';

/// This is settings page
///
/// [SettingPage] contains a title and several [GroupedTile]
/// wrapped by [Column]
class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
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
            onTap: () => ref.read(settingsProvider.notifier).updatePath(),
          ),
          ListTile(
            title: Text("rebuild index"),
            trailing:
                Text(state.dbRebuiltTime?.split('.')[0] ?? "not yet built"),
            onTap: () => ref.read(settingsProvider.notifier).rebuildDb(),
          ),
          ListTile(
              title: Text("default speed"),
              trailing: Text(state.defaultPlaybackSpeed.toString()),
              onTap: () => {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SpeedSelectionBottomSheet(
                        initialSpeed: state.defaultPlaybackSpeed,
                        onSpeedSelected: (newSpeed) {
                          ref
                              .read(settingsProvider.notifier)
                              .changeDefaultPlaybackSpeed(newSpeed);
                        },
                      ),
                    ),
                  }),
        ]),

        /// == GroupedTile: Appearance ==
        SizedBox(
          height: 20,
        ),
        GroupedTile(children: [
          ListTile(
            title: Text("show album cover"),
            trailing: state.showCover ? Icon(Icons.check) : null,
            onTap: () => ref.read(settingsProvider.notifier).changeShowCover(),
          ),
          ListTile(
            title: Text("clean up file name"),
            trailing: state.cleanFileName ? Icon(Icons.check) : null,
            onTap: () =>
                ref.read(settingsProvider.notifier).changeCleanFileName(),
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
            onTap: () => ref.read(settingsProvider.notifier).changeSeedColor(),
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
  }
}
