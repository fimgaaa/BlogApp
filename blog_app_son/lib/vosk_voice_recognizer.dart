import 'package:vosk_flutter/vosk_flutter.dart';

import 'voice_recognizer.dart';

/// Simplified recognizer implementation using the Vosk plugin.
class VoskVoiceRecognizer implements IVoiceRecognizer {
  final VoskFlutter _vosk = VoskFlutter();

  @override
  Future<bool> initialize() async {
    await _vosk.init();
    return true;
  }

  @override
  void listen({
    required void Function(String text, bool finalResult) onResult,
  }) {
    _vosk.start(
      onResult: (text, isFinal) {
        onResult(text, isFinal);
      },
    );
  }

  @override
  void stop() {
    _vosk.stop();
  }
}
