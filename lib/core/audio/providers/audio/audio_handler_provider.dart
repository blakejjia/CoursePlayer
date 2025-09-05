import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'audio_controller.dart';

// Provider for the future of the audio handler
final audioHandlerFutureProvider = FutureProvider<MyAudioHandler>((ref) async {
  final handler = await initAudioService();
  ref.onDispose(() => handler.dispose());
  return handler;
});

// Legacy provider that throws error - replaced by the future provider
final audioHandlerProvider = Provider<MyAudioHandler>((ref) {
  throw UnimplementedError('Use audioHandlerFutureProvider instead');
});
