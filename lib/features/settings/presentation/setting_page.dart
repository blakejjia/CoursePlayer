import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/settings/presentation/widgets/grouped_tile.dart';
import 'package:lemon/features/settings/presentation/widgets/speed_selection_bs.dart';
import 'package:lemon/features/settings/providers/settings_provider.dart';
import 'package:go_router/go_router.dart';

/// This is settings page
class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        GroupedTile(title: "Index", children: [
          ListTile(
            leading: Icon(Icons.book_outlined),
            title: Text("select dictionary"),
            subtitle: Text(state.audioPath),
            onTap: () => ref.read(settingsProvider.notifier).updatePath(),
          ),
          ListTile(
            leading: Icon(Icons.cached_outlined),
            title: Text("rebuild index"),
            subtitle: Text(_formatDate(state.dbRebuiltTime)),
            onTap: () => ref.read(settingsProvider.notifier).rebuildDb(),
          ),
        ]),

        /// == GroupedTile: Appearance ==
        GroupedTile(title: "Other Settings", children: [
          ListTile(
              leading: Icon(Icons.speed_outlined),
              title: Text("default speed"),
              trailing: Text(state.defaultPlaybackSpeed.toString()),
              onTap: () => {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      useSafeArea: true,
                      builder: (context) => SpeedSelectionBS(
                        initialSpeed: state.defaultPlaybackSpeed,
                        onSpeedSelected: (newSpeed) {
                          ref
                              .read(settingsProvider.notifier)
                              .changeDefaultPlaybackSpeed(newSpeed);
                        },
                      ),
                    ),
                  }),
          ListTile(
            leading: Icon(Icons.album_outlined),
            title: Text("show album cover"),
            trailing: Switch(
                value: state.showCover,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).changeShowCover();
                }),
          ),
          ListTile(
            leading: Icon(Icons.cleaning_services_outlined),
            title: Text("clean up file name"),
            trailing: Switch(
                value: state.cleanFileName,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).changeCleanFileName();
                }),
          ),
          ListTile(
            leading: Icon(Icons.color_lens_outlined),
            title: Text("theme color"),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: state.seedColor, // 使用传入的seedColor
                shape: BoxShape.circle, // 圆形
              ),
            ),
            onTap: () => ref.read(settingsProvider.notifier).changeSeedColor(),
          ),
          ListTile(
            leading: Icon(Icons.auto_awesome),
            title: Text("Gemini API Key"),
            subtitle: Text(state.geminiApiKey.isEmpty
                ? "Not set"
                : "••••••••${state.geminiApiKey.substring(state.geminiApiKey.length - 4 >= 0 ? state.geminiApiKey.length - 4 : 0)}"),
            onTap: () => _showApiKeyDialog(context, ref, state.geminiApiKey),
          ),
        ]),

        /// == GroupedTile: other ==
        GroupedTile(children: [
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("tutorial& author"),
            onTap: () {
              context.push('/info');
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

Future<void> _showApiKeyDialog(
    BuildContext context, WidgetRef ref, String currentKey) async {
  final controller = TextEditingController(text: currentKey);
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Enter Gemini API Key'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Paste your API key here',
          helperText: 'Only Gemini AI Studio keys are supported.',
        ),
        obscureText: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            ref
                .read(settingsProvider.notifier)
                .updateGeminiApiKey(controller.text.trim());
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

// ================= utils ======================
String _formatDate(DateTime? dt) {
  if (dt == null) return "not yet built";
  if (dt == DateTime.fromMicrosecondsSinceEpoch(0)) return "indexing songs...";
  return "last index: ${dt.toString().split('.')[0]}";
}
