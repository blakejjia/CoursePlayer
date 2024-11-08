part of 'settings_cubit.dart';

class SettingsState {
  final String audioPath;


  const SettingsState({
    required this.audioPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'audioPath': audioPath,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      audioPath: map['audioPath'] as String,
    );
  }

  SettingsState copyWith({
    String? audioPath,
  }) {
    return SettingsState(
      audioPath: audioPath ?? this.audioPath,
    );
  }
}
