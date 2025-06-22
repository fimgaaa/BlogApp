import 'package:vosk_flutter/vosk_flutter.dart';

import 'voice_recognizer.dart';

class VoskVoiceRecognizer implements IVoiceRecognizer {
  late final SpeechService _speechService;

  @override
  Future<bool> initialize() async {
    final model = await VoskModel.loadAssets(
      'assets/models/vosk-model-small-tr-0.3',
    );
    _speechService = SpeechService(model);
    return true;
  }

  @override
  void listen({
    required void Function(String text, bool finalResult) onResult,
  }) {
    _speechService.start(
      onResult: (text, isFinal) {
        onResult(text, isFinal);
      },
    );
  }

  @override
  void stop() {
    _speechService.stop();
  }
}
