import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  VoiceService._internal() {
    _flutterTts.setLanguage('tr-TR');
  }

  static final VoiceService instance = VoiceService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
