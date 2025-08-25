import 'package:flutter/material.dart';

class SettingsState {
  final String audioPath;
  final String? dbRebuiltTime;
  final bool showCover;
  final bool cleanFileName;
  final Color seedColor;
  final double defaultPlaybackSpeed;

  const SettingsState({
    required this.audioPath,
    required this.dbRebuiltTime,
    required this.cleanFileName,
    required this.showCover,
    required this.seedColor,
    required this.defaultPlaybackSpeed,
  });

  Map<String, dynamic> toMap() {
    return {
      'audioPath': audioPath,
      'dbRebuiltTime': dbRebuiltTime,
      'showCover': showCover,
      'cleanFileName': cleanFileName,
      'seedColor': seedColor.value,
      'defaultPlaybackSpeed': defaultPlaybackSpeed,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      audioPath: map['audioPath'] as String,
      dbRebuiltTime: map['dbRebuiltTime'] as String?,
      cleanFileName: map['cleanFileName'] as bool,
      showCover: map['showCover'] as bool,
      seedColor: Color(map['seedColor'] as int),
      defaultPlaybackSpeed: (map['defaultPlaybackSpeed'] as num).toDouble(),
    );
  }

  SettingsState copyWith({
    String? audioPath,
    String? dbRebuiltTime,
    bool? cleanFileName,
    bool? showCover,
    Color? seedColor,
    double? defaultPlaybackSpeed,
  }) {
    return SettingsState(
      audioPath: audioPath ?? this.audioPath,
      dbRebuiltTime: dbRebuiltTime ?? this.dbRebuiltTime,
      cleanFileName: cleanFileName ?? this.cleanFileName,
      showCover: showCover ?? this.showCover,
      seedColor: seedColor ?? this.seedColor,
      defaultPlaybackSpeed: defaultPlaybackSpeed ?? this.defaultPlaybackSpeed,
    );
  }
}
