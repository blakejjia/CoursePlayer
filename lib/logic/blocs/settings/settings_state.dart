part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  bool islistview;

//<editor-fold desc="Data Methods">
  SettingsState({
    required this.islistview,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is SettingsState &&
              runtimeType == other.runtimeType &&
              islistview == other.islistview);

  @override
  int get hashCode => islistview.hashCode;

  @override
  String toString() {
    return 'SettingsState{' + ' islistview: $islistview,' + '}';
  }

  SettingsState copyWith({
    bool? isListView,
  }) {
    return SettingsState(
      islistview: isListView ?? this.islistview,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'islistview': this.islistview,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      islistview: map['islistview'] as bool,
    );
  }

  @override
  List<Object> get props => [islistview];
//</editor-fold>
}