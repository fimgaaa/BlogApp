import 'package:blog_app_son/voice_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceAssistantOverlay extends StatefulWidget {
  final Widget child;
  final IVoiceRecognizer recognizer;
  const VoiceAssistantOverlay({
    Key? key,
    required this.child,
    required this.recognizer,
  }) : super(key: key);

  @override
  State<VoiceAssistantOverlay> createState() => _VoiceAssistantOverlayState();
}

class _VoiceAssistantOverlayState extends State<VoiceAssistantOverlay> {
  late final IVoiceRecognizer _recognizer = widget.recognizer;
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
    _initialized = await _recognizer.initialize();
    if (_initialized) {
      _listenForWakeWord();
    }
  }

  void _listenForWakeWord() {
    if (!_initialized) return;
    _recognizer.listen(
      onResult: (text, finalResult) {
        final lower = text.toLowerCase();
        if (finalResult && lower.contains(_wakeWord)) {
          _recognizer.stop();
          _startListening();
        }
      },
    );
  }

  Future<void> _startListening() async {
    if (!_initialized) return;
    setState(() => _isListening = true);
    _recognizer.listen(
      onResult: (text, finalResult) {
        if (finalResult && text.isNotEmpty) {
          _tts.speak(text);
          _stopListening();
        }
      },
    );
  }

  void _stopListening() {
    _recognizer.stop();
    setState(() => _isListening = false);
    _listenForWakeWord();
  }

  void _toggle() {
    if (_isListening) {
      _stopListening();
    } else {
      _recognizer.stop();
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
