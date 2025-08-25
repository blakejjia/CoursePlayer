import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemon/features/settings/providers/settings_state.dart';
import 'package:lemon/features/album/bloc/album_page_cubit.dart';
import 'package:lemon/main.dart';

class SettingsService extends ChangeNotifier {
  static const _kAudioPath = 'audioPath';
  static const _kDbRebuiltTime = 'dbRebuiltTime';
  static const _kShowCover = 'showCover';
  static const _kCleanFileName = 'cleanFileName';
  static const _kSeedColor = 'seedColor';
  static const _kDefaultPlaybackSpeed = 'defaultPlaybackSpeed';

  SettingsState _state = const SettingsState(
    audioPath: "/storage/emulated/0/courser",
    dbRebuiltTime: null,
    seedColor: Colors.blue,
    showCover: true,
    cleanFileName: true,
    defaultPlaybackSpeed: 1.0,
  );

  SettingsState get state => _state;

  SettingsService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _state = SettingsState(
      audioPath: prefs.getString(_kAudioPath) ?? _state.audioPath,
      dbRebuiltTime: prefs.getString(_kDbRebuiltTime),
      showCover: prefs.getBool(_kShowCover) ?? _state.showCover,
      cleanFileName: prefs.getBool(_kCleanFileName) ?? _state.cleanFileName,
      seedColor: Color(prefs.getInt(_kSeedColor) ?? _state.seedColor.value),
      defaultPlaybackSpeed: prefs.getDouble(_kDefaultPlaybackSpeed) ??
          _state.defaultPlaybackSpeed,
    );
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAudioPath, _state.audioPath);
    if (_state.dbRebuiltTime != null) {
      await prefs.setString(_kDbRebuiltTime, _state.dbRebuiltTime!);
    }
    await prefs.setBool(_kShowCover, _state.showCover);
    await prefs.setBool(_kCleanFileName, _state.cleanFileName);
    await prefs.setInt(_kSeedColor, _state.seedColor.value);
    await prefs.setDouble(_kDefaultPlaybackSpeed, _state.defaultPlaybackSpeed);
  }

  Future<void> updatePath() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      _state = _state.copyWith(audioPath: path);
      await _persist();
      notifyListeners();
    }
    getIt<AlbumPageCubit>().loaddb();
  }

  void stateRebuilding() {
    _state = _state.copyWith(dbRebuiltTime: "indexing songs...");
    notifyListeners();
  }

  void rebuildDb() {
    if (_state.dbRebuiltTime == "indexing songs...") {
      return;
    }
    _state = _state.copyWith(dbRebuiltTime: "indexing songs...");
    notifyListeners();
    getIt<AlbumPageCubit>().loaddb();
  }

  Future<void> updateRebuiltTime() async {
    _state = _state.copyWith(dbRebuiltTime: "index finished");
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _state = _state.copyWith(dbRebuiltTime: "latest index: ${DateTime.now()}");
    await _persist();
    notifyListeners();
  }

  Future<void> changeShowCover() async {
    _state = _state.copyWith(showCover: !_state.showCover);
    await _persist();
    notifyListeners();
  }

  Future<void> changeCleanFileName() async {
    _state = _state.copyWith(cleanFileName: !_state.cleanFileName);
    await _persist();
    notifyListeners();
  }

  Future<void> changeDefaultPlaybackSpeed(double speed) async {
    _state = _state.copyWith(defaultPlaybackSpeed: speed);
    await _persist();
    notifyListeners();
  }

  Future<void> changeSeedColor() async {
    List<Color> colors = [
      Colors.red,
      Colors.pink,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
    ];
    int currentIndex = colors.indexOf(_state.seedColor);
    int nextIndex = (currentIndex + 1) % colors.length;
    _state = _state.copyWith(seedColor: colors[nextIndex]);
    await _persist();
    notifyListeners();
  }
}
