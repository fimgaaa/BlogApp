import 'package:blog_app_son/speech_to_text_recognizer.dart';
import 'package:blog_app_son/voice_assistant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'home_page.dart';

//void main() {
//runApp(MyApp());
//}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog Uygulaması',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      builder:
          (context, child) => VoiceAssistantOverlay(
            child: child!,
            recognizer: SpeechToTextRecognizer(),
          ),
    );
  }
}
