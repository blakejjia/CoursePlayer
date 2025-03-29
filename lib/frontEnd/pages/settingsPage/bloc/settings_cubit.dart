import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lemon/frontEnd/pages/CoursesPage/albumPage/bloc/album_page_cubit.dart';
import 'package:lemon/main.dart';
part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
            audioPath: "/storage/emulated/0/courser",
            dbRebuiltTime: null,
            seedColor: Colors.blue,
            showCover: true,
            cleanFileName: true,
            defaultPlaybackSpeed: 1.0));

  Future<void> updatePath() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      emit(state.copyWith(audioPath: path));
    }
    getIt<AlbumPageCubit>().loaddb();
  }

  void stateRebuilding() {
    emit(state.copyWith(dbRebuiltTime: "indexing songs..."));
  }

  void rebuildDb() {
    if (state.dbRebuiltTime == "indexing songs...") {
      return;
    }
    emit(state.copyWith(dbRebuiltTime: "indexing songs..."));
    getIt<AlbumPageCubit>().loaddb();
  }

  void updateRebuiltTime() async {
    emit(state.copyWith(dbRebuiltTime: "index finished"));
    await Future.delayed(Duration(seconds: 1));
    emit(state.copyWith(dbRebuiltTime: "latest index: ${DateTime.now()}"));
  }

  void changeShowCover() {
    emit(state.copyWith(showCover: !state.showCover));
  }

  void changeCleanFileName() {
    emit(state.copyWith(cleanFileName: !state.cleanFileName));
  }

  void changeDefaultPlaybackSpeed(double speed) {
    emit(state.copyWith(defaultPlaybackSpeed: speed));
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
