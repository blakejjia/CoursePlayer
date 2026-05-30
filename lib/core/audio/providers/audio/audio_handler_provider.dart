import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'audio_controller.dart';

// Provider for the future of the audio handler
final audioHandlerFutureProvider = FutureProvider<MyAudioHandler>((ref) async {
  // Request notification permission (critical for background service notifications on Android 13+)
  try {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  } catch (e) {
    // ignore permission failures (e.g. on non-mobile platforms)
  }

  final handler = await initAudioService();
  ref.onDispose(() => handler.dispose());
  return handler;
});

// Legacy provider that throws error - replaced by the future provider
final audioHandlerProvider = Provider<MyAudioHandler>((ref) {
  throw UnimplementedError('Use audioHandlerFutureProvider instead');
});
