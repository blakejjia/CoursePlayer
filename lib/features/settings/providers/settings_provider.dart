import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemon/features/settings/providers/settings_state.dart';
import 'package:lemon/features/album/bloc/album_page_cubit.dart';
import 'package:lemon/main.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const _kAudioPath = 'audioPath';
  static const _kDbRebuiltTime = 'dbRebuiltTime';
  static const _kShowCover = 'showCover';
  static const _kCleanFileName = 'cleanFileName';
  static const _kSeedColor = 'seedColor';
  static const _kDefaultPlaybackSpeed = 'defaultPlaybackSpeed';

  SettingsNotifier()
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
      dbRebuiltTime: prefs.getString(_kDbRebuiltTime),
      showCover: prefs.getBool(_kShowCover) ?? fallback.showCover,
      cleanFileName: prefs.getBool(_kCleanFileName) ?? fallback.cleanFileName,
      seedColor: Color(prefs.getInt(_kSeedColor) ?? fallback.seedColor.value),
      defaultPlaybackSpeed: prefs.getDouble(_kDefaultPlaybackSpeed) ??
          fallback.defaultPlaybackSpeed,
    );
    if (state != loaded) state = loaded;
  }

  Future<void> _persist(SettingsState s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAudioPath, s.audioPath);
    if (s.dbRebuiltTime != null) {
      await prefs.setString(_kDbRebuiltTime, s.dbRebuiltTime!);
    }
    await prefs.setBool(_kShowCover, s.showCover);
    await prefs.setBool(_kCleanFileName, s.cleanFileName);
    await prefs.setInt(_kSeedColor, s.seedColor.value);
    await prefs.setDouble(_kDefaultPlaybackSpeed, s.defaultPlaybackSpeed);
  }

  Future<void> updatePath() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      final next = state.copyWith(audioPath: path);
      state = next;
      await _persist(next);
    }
    getIt<AlbumPageCubit>().loaddb();
  }

  void stateRebuilding() {
    state = state.copyWith(dbRebuiltTime: "indexing songs...");
  }

  void rebuildDb() {
    if (state.dbRebuiltTime == "indexing songs...") {
      return;
    }
    state = state.copyWith(dbRebuiltTime: "indexing songs...");
    getIt<AlbumPageCubit>().loaddb();
  }

  Future<void> updateRebuiltTime() async {
    state = state.copyWith(dbRebuiltTime: "index finished");
    await Future.delayed(const Duration(seconds: 1));
    final next =
        state.copyWith(dbRebuiltTime: "latest index: ${DateTime.now()}");
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
  return SettingsNotifier();
});
