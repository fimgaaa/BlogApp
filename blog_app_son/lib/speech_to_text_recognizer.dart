import 'package:speech_to_text/speech_to_text.dart';

import 'voice_recognizer.dart';

class SpeechToTextRecognizer implements IVoiceRecognizer {
  final SpeechToText _speech = SpeechToText();

  @override
  Future<bool> initialize() => _speech.initialize();

  @override
  void listen({
    required void Function(String text, bool finalResult) onResult,
  }) {
    _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
    );
  }

  @override
  void stop() {
    _speech.stop();
  }
}
