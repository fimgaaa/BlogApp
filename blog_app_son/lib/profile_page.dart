import 'package:blog_app_son/all_blogs.dart'; // Tüm blog yazıları için
import 'package:blog_app_son/blog_posts.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _profileImage = 'assets/profile_picture.jpg';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Feyza IMGA';
    _bioController.text =
        'Blog yazarı, teknoloji ve seyahat tutkunu. Hayatımı renkli yazılarla şekillendiriyorum!';
    _emailController.text = 'yaziciyildiz@example.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Profilim"),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Profil Fotoğrafı
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _profileImage = 'assets/another_profile_picture.jpg';
                  });
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(_profileImage),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Kullanıcı Adı
            _isEditing
                ? TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı",
                    border: OutlineInputBorder(),
                  ),
                )
                : Center(
                  child: Text(
                    _nameController.text,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
            SizedBox(height: 10),

            // Biyografi
            _isEditing
                ? TextField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Biyografi",
                    border: OutlineInputBorder(),
                  ),
                )
                : Center(
                  child: Text(
                    _bioController.text,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
            SizedBox(height: 10),

            // E-posta Adresi ve Şifre
            if (_isEditing) ...[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "E-posta",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
            ],

            // Profil Düzenleme Butonu
            ElevatedButton(
              onPressed: () {
                //setState() çağrılıyor , ekranın yeniden çizilmesini sağlar.
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              child: Text(
                _isEditing ? 'Değişiklikleri Kaydet' : 'Profilimi Düzenle',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isEditing ? Colors.pinkAccent : Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            /*
            // Yeni Yazı Ekleme
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Yeni yazı sayfasına yönlendirme
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NewPostPage()), // Burada yönlendirme yapılır
                  );
                },
                child: Text('Yeni Yazı Yaz'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 20),
*/
            // Yazılarım Butonu
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlogPostsPage()),
                  );
                },
                child: Text('Yazılarım'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Tüm Blog Yazıları
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllBlogsPage()),
                  );
                },
                child: Text('Tüm Blog Yazıları'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
