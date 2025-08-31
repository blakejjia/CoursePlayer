import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemon/core/audio/providers/audio/audio_player_provider.dart';

/// Service that handles app lifecycle changes and ensures progress is saved
/// when the app goes to background or is being terminated
class AppLifecycleService with WidgetsBindingObserver {
  final Ref ref;

  AppLifecycleService(this.ref) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    debugPrint('App lifecycle state changed: $state');

    switch (state) {
      case AppLifecycleState.paused:
        // App is going to background
        _saveProgressOnBackground();
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        _saveProgressOnTermination();
        break;
      case AppLifecycleState.inactive:
        // App is temporarily inactive (phone call, etc.)
        _saveProgressOnInactive();
        break;
      case AppLifecycleState.resumed:
        // App is coming back to foreground
        _onAppResumed();
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        _saveProgressOnHidden();
        break;
    }
  }

  void _saveProgressOnBackground() {
    debugPrint('App going to background - saving progress');
    _saveCurrentProgress();
  }

  void _saveProgressOnTermination() {
    debugPrint('App being terminated - saving progress');
    _saveCurrentProgress();
  }

  void _saveProgressOnInactive() {
    debugPrint('App inactive - saving progress');
    _saveCurrentProgress();
  }

  void _saveProgressOnHidden() {
    debugPrint('App hidden - saving progress');
    _saveCurrentProgress();
  }

  void _onAppResumed() {
    debugPrint('App resumed from background');
    // Could refresh UI or check for changes here
  }

  void _saveCurrentProgress() {
    try {
      final notifier = ref.read(audioPlayerProvider.notifier);
      notifier.saveProgress();
    } catch (e) {
      debugPrint('Error saving progress in lifecycle service: $e');
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

/// Provider for the app lifecycle service
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  final service = AppLifecycleService(ref);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});
