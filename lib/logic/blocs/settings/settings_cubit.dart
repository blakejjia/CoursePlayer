import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit()
      : super(const SettingsState(audioPath: "/storage/emulated/0/courser"));

  void setPath(String path){
    emit(state.copyWith(audioPath: path));
  }

  String getPath(){
    return state.audioPath;
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
