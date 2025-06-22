<<<<<<< HEAD
=======
import 'package:blog_app_son/voice_assistant.dart';
>>>>>>> parent of 3495cae (vosk)
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
<<<<<<< HEAD
=======
      builder: (context, child) => VoiceAssistantOverlay(child: child!),
>>>>>>> parent of 3495cae (vosk)
    );
  }
}
