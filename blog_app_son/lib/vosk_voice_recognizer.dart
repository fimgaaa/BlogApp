import 'package:vosk_flutter/vosk_flutter.dart';

class VoskVoiceRecognizer {
  final VoskFlutter vosk = VoskFlutter();

  Future<void> init() async {
    await vosk.init(modelPath: 'assets/models/vosk-model-small-tr-0.3');
  }

  void startListening() {
    vosk.start();
    vosk.onPartial = (text) {
      print("Partial: $text");
    };
    vosk.onResult = (text) {
      print("Final: $text");
    };
  }

  void stopListening() {
    vosk.stop();
  }
}
