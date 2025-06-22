import 'package:blog_app_son/all_blogs.dart';
import 'package:blog_app_son/services/voice_services.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnlatApp'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              VoiceService.instance.speak('Hoş Geldiniz');
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              VoiceService.instance.stop();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/home.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '🌟 Hoş Geldiniz 🌟',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // LoginPage'e yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('🚀 Giriş Yap / Kayıt Ol'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Ziyaretçi Olarak Devam Et butonuna tıklandığında AllBlogsPage'e yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllBlogsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('📖 Ziyaretçi Olarak Devam Et'),
            ),
          ],
        ),
      ),
    );
  }
}
