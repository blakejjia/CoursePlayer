import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
            audioPath: "/storage/emulated/0/courser",
            dbRebuiltTime: null,
            seedColor: Colors.blue,
            showCover: true,
            cleanFileName: true));

  void setPath(String path) {
    emit(state.copyWith(audioPath: path));
  }

  void stateRebuilding() {
    emit(state.copyWith(dbRebuiltTime: "正在重构, 这不会消耗太久"));
  }

  void updateRebuiltTime() async {
    emit(state.copyWith(dbRebuiltTime: "重构完成"));
    await Future.delayed(Duration(seconds: 1));
    emit(state.copyWith(dbRebuiltTime: "最近一次重构: ${DateTime.now()}"));
  }

  void changeShowCover() {
    emit(state.copyWith(showCover: !state.showCover));
  }

  void changeCleanFileName() {
    emit(state.copyWith(cleanFileName: !state.cleanFileName));
  }

  void changeSeedColor() {
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
    int currentIndex = colors.indexOf(state.seedColor);
    int nextIndex = (currentIndex + 1) % colors.length;
    emit(state.copyWith(seedColor: colors[nextIndex]));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toMap();
  }
}
