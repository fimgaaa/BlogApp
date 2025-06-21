import 'dart:io';

import 'package:blog_app_son/all_blogs.dart';
import 'package:blog_app_son/blog_posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _profileImage = 'lib/images/avatar.png';
  final ImagePicker _picker = ImagePicker();
  XFile? _newImageFile;
  bool _isEditing = false;
  String _email = '';
  String _joinedDate = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      _email = user.email ?? '';
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        if (!mounted) return;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _bioController.text = data['bio'] ?? '';
          _instagramController.text = data['instagram'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _profileImage = data['imageUrl'] ?? _profileImage;
          _joinedDate = data['joinedDate'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profil yüklenemedi: $e')));
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked != null) {
        if (!mounted) return;
        setState(() {
          _newImageFile = picked;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Resim seçilemedi: $e')));
    }
  }

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'Giriş yapılmadı';

      String imageUrl = _profileImage;
      if (_newImageFile != null) {
        //   final ref = FirebaseStorage.instance.ref('profile_images/${user.uid}');
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = FirebaseStorage.instance.ref().child(
          'profile_images/${user.uid}/$fileName',
        );
        await ref.putFile(File(_newImageFile!.path));
        imageUrl = await ref.getDownloadURL();
        // Remove old profile image if it exists and is a network resource
        if (_profileImage.startsWith('http') && _profileImage != imageUrl) {
          try {
            await FirebaseStorage.instance.refFromURL(_profileImage).delete();
          } catch (_) {}
        }
      }

      /*   await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'bio': _bioController.text,
        'instagram': _instagramController.text,
        'phone': _phoneController.text,
        'imageUrl': imageUrl,
        'joinedDate':
            _joinedDate.isNotEmpty
                ? _joinedDate
                : DateTime.now().toIso8601String(),
      });*/
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'bio': _bioController.text,
        'instagram': _instagramController.text,
        'phone': _phoneController.text,
        'imageUrl': imageUrl,
        'joinedDate':
            _joinedDate.isNotEmpty
                ? _joinedDate
                : DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
      if (!mounted) return;
      setState(() {
        _isEditing = false;
        _profileImage = imageUrl;
        _newImageFile = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profil güncellendi')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
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
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        _newImageFile != null
                            ? FileImage(File(_newImageFile!.path))
                            : _profileImage.startsWith('http')
                            ? NetworkImage(_profileImage)
                            : AssetImage(_profileImage) as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 25,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
            Center(
              child: Text(
                _email,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            SizedBox(height: 10),
            if (_isEditing)
              TextField(
                controller: _instagramController,
                decoration: InputDecoration(
                  labelText: "Instagram",
                  border: OutlineInputBorder(),
                ),
              )
            else
              Center(child: Text("Instagram: ${_instagramController.text}")),
            SizedBox(height: 10),
            if (_isEditing)
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Telefon",
                  border: OutlineInputBorder(),
                ),
              )
            else
              Center(child: Text("Telefon: ${_phoneController.text}")),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Kayıt Tarihi: ${_joinedDate.isNotEmpty ? _joinedDate.split('T').first : 'Bilinmiyor'}",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
              child: Text(
                _isEditing ? 'Değişiklikleri Kaydet' : 'Profilimi Düzenle',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BlogPostsPage()),
                );
              },
              child: Text("Yazılarım"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AllBlogsPage()),
                );
              },
              child: Text("Tüm Blog Yazıları"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _instagramController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
