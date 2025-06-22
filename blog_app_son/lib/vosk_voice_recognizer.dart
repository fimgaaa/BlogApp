import 'package:vosk_flutter/vosk_flutter.dart';

class VoskVoiceRecognizer {
  late SpeechService _speechService;

  Future<void> init() async {
    final modelLoader = ModelLoader();
    final modelPath = await modelLoader.loadFromAssets(
      'models/vosk-model-small-tr-0.3',
    );
    final model = await VoskFlutterPlugin.instance().createModel(modelPath);
    final recognizer = await VoskFlutterPlugin.instance().createRecognizer(
      model: model,
      sampleRate: 16000,
    );
    _speechService = await VoskFlutterPlugin.instance().initSpeechService(
      recognizer,
    );

    _speechService.onPartial().listen((partial) {
      print("Partial: $partial");
    });

    _speechService.onResult().listen((result) {
      print("Final: $result");
    });
  }

  Future<void> startListening() async {
    await _speechService.start();
  }

  Future<void> stopListening() async {
    await _speechService.stop();
  }
}
