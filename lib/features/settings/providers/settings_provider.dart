import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/features/albums/providers/album_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemon/features/settings/providers/settings_state.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;
  static const _kAudioPath = 'audioPath';
  static const _kDbRebuiltTime = 'dbRebuiltTime';
  static const _kShowCover = 'showCover';
  static const _kCleanFileName = 'cleanFileName';
  static const _kSeedColor = 'seedColor';
  static const _kDefaultPlaybackSpeed = 'defaultPlaybackSpeed';

  SettingsNotifier(this.ref)
      : super(const SettingsState(
          audioPath: "/storage/emulated/0/courser",
          dbRebuiltTime: null,
          seedColor: Colors.blue,
          showCover: true,
          cleanFileName: true,
          defaultPlaybackSpeed: 1.0,
        )) {
    _loadFromPrefs(state);
  }

  Future<void> _loadFromPrefs(SettingsState fallback) async {
    final prefs = await SharedPreferences.getInstance();
    final loaded = SettingsState(
      audioPath: prefs.getString(_kAudioPath) ?? fallback.audioPath,
      dbRebuiltTime: prefs.getString(_kDbRebuiltTime) != null
          ? DateTime.parse(prefs.getString(_kDbRebuiltTime)!)
          : null,
      showCover: prefs.getBool(_kShowCover) ?? fallback.showCover,
      cleanFileName: prefs.getBool(_kCleanFileName) ?? fallback.cleanFileName,
      seedColor:
          Color(prefs.getInt(_kSeedColor) ?? fallback.seedColor.toARGB32()),
      defaultPlaybackSpeed: prefs.getDouble(_kDefaultPlaybackSpeed) ??
          fallback.defaultPlaybackSpeed,
    );
    if (state != loaded) state = loaded;
  }

  Future<void> _persist(SettingsState s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAudioPath, s.audioPath);
    if (s.dbRebuiltTime != null) {
      await prefs.setString(
          _kDbRebuiltTime, s.dbRebuiltTime!.toIso8601String());
    }
    await prefs.setBool(_kShowCover, s.showCover);
    await prefs.setBool(_kCleanFileName, s.cleanFileName);
    await prefs.setInt(_kSeedColor, s.seedColor.toARGB32());
    await prefs.setDouble(_kDefaultPlaybackSpeed, s.defaultPlaybackSpeed);
  }

  Future<void> updatePath() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      final next = state.copyWith(audioPath: path);
      state = next;
      await _persist(next);
    }
    // Avoid reading `settingsProvider` from inside its own notifier
    // (causes a self-dependency). Use the current state instead.
    ref.read(albumProvider.notifier).loaddb(state.audioPath);
  }

  void stateRebuilding() {
    state =
        state.copyWith(dbRebuiltTime: DateTime.fromMicrosecondsSinceEpoch(0));
  }

  void rebuildDb() {
    if (state.dbRebuiltTime == DateTime.fromMicrosecondsSinceEpoch(0)) {
      return;
    }
    state =
        state.copyWith(dbRebuiltTime: DateTime.fromMicrosecondsSinceEpoch(0));
    // Use `state.audioPath` instead of reading the provider to avoid
    // a provider depending on itself.
    ref.read(albumProvider.notifier).loaddb(state.audioPath);
  }

  Future<void> updateRebuiltTime() async {
    final next = state.copyWith(dbRebuiltTime: DateTime.now());
    state = next;
    await _persist(next);
  }

  Future<void> changeShowCover() async {
    final next = state.copyWith(showCover: !state.showCover);
    state = next;
    await _persist(next);
  }

  Future<void> changeCleanFileName() async {
    final next = state.copyWith(cleanFileName: !state.cleanFileName);
    state = next;
    await _persist(next);
  }

  Future<void> changeDefaultPlaybackSpeed(double speed) async {
    final next = state.copyWith(defaultPlaybackSpeed: speed);
    state = next;
    await _persist(next);
  }

  Future<void> changeSeedColor() async {
    List<Color> colors = const [
      Colors.red,
      Colors.pink,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
    ];
    int currentIndex = colors.indexOf(state.seedColor);
    int nextIndex = (currentIndex + 1) % colors.length;
    final next = state.copyWith(seedColor: colors[nextIndex]);
    state = next;
    await _persist(next);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});
