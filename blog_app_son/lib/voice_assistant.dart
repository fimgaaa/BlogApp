import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceAssistantOverlay extends StatefulWidget {
  final Widget child;
  const VoiceAssistantOverlay({Key? key, required this.child})
    : super(key: key);

  @override
  State<VoiceAssistantOverlay> createState() => _VoiceAssistantOverlayState();
}

class _VoiceAssistantOverlayState extends State<VoiceAssistantOverlay> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  bool _initialized = false;

  static const String _wakeWord = 'hey asistan';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _initialized = await _speech.initialize();
    if (_initialized) {
      _listenForWakeWord();
    }
  }

  void _listenForWakeWord() {
    if (!_initialized) return;
    _speech.listen(
      onResult: (result) {
        final text = result.recognizedWords.toLowerCase();
        if (result.finalResult && text.contains(_wakeWord)) {
          _speech.stop();
          _startListening();
        }
      },
      partialResults: true,
      listenMode: ListenMode.dictation,
    );
  }

  Future<void> _startListening() async {
    if (!_initialized) return;
    setState(() => _isListening = true);
    _speech.listen(
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          _tts.speak(result.recognizedWords);
          _stopListening();
        }
      },
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    _listenForWakeWord();
  }

  void _toggle() {
    if (_isListening) {
      _stopListening();
    } else {
      _speech.stop();
      _startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _toggle,
            backgroundColor: _isListening ? Colors.red : Colors.blue,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
      ],
    );
  }
}
