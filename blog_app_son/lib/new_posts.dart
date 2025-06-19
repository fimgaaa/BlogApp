import 'dart:io'; // File sınıfı için eklendi

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // image_picker paketi eklendi

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'Teknoloji';
  bool _isPublished = false;

  final ImagePicker _picker = ImagePicker(); // ImagePicker nesnesi
  XFile? _selectedImageFile; // Seçilen resim dosyasını tutacak değişken

  @override
  void dispose() {
    //widget kullanılmayacaksa hafızayı temizler
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // resim seçme fonksiyonu
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source, // Kaynak (Galeri veya Kamera)
        imageQuality: 80, // Resim kalitesi
        maxWidth: 1000,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = pickedFile;
        });
      } else {
        print("Resim seçilmedi.");
      }
    } catch (e) {
      print("Resim seçme hatası: $e");

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Resim seçilemedi: $e')));
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galeriden Seç'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Kameradan Çek'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              // Eğer resim seçiliyse kaldırma seçeneği
              if (_selectedImageFile != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Resmi Kaldır',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedImageFile = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _savePost() {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      // yeni gönderi verisi oluşturur
      final newPostData = {
        'title': _titleController.text,
        'content': _contentController.text,
        'category': _selectedCategory,
        'author': 'Yeni Kullanıcı', // Şimdilik sabit bir yazar adı
        'imagePath': _selectedImageFile?.path, // Resim yolunu ekle
        'isPublished': _isPublished.toString(), // Yayın durumunu ekle
      };

      print("--- Yeni Blog Yazısı Oluşturuldu ---");
      print("Başlık: ${newPostData['title']}");
      print("İçerik: ${newPostData['content']}");
      print("Kategori: ${newPostData['category']}");
      print("Yazar: ${newPostData['author']}");
      print("Seçilen Resim Yolu: ${newPostData['imagePath'] ?? 'Yok'}");
      print("Yayın Durumu: ${_isPublished ? 'Yayınlandı' : 'Taslak'}");
      print("------------------------------------");

      // Başarılı kayıttan sonra sayfayı kapat ve yeni veriyi geri dönfür
      if (mounted) {
        Navigator.of(
          context,
        ).pop(newPostData); // Oluşturulan veriyi geri döndür
      }
    } else {
      // Kullanıcıya eksik alanlar olduğunu bildir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen başlık ve içerik alanlarını doldurun.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Blog Yazısı"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: "Kaydet",
            onPressed: _savePost,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Başlık",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: "İçerik",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 8,
              minLines: 5,
            ),
            SizedBox(height: 15),

            //resim seçme alanı
            Text("Kapak Resmi", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  // Seçilen resmi gösterme
                  if (_selectedImageFile != null)
                    ClipRRect(
                      // Köşeleri yuvarlatmak için
                      borderRadius: BorderRadius.circular(5),
                      child: Image.file(
                        File(_selectedImageFile!.path),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    // Resim seçilmediyse bir ikon göster
                    Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey[500],
                      ),
                    ),
                  SizedBox(height: 10),

                  TextButton.icon(
                    icon: Icon(
                      _selectedImageFile == null
                          ? Icons.add_photo_alternate
                          : Icons.edit,
                    ),
                    label: Text(
                      _selectedImageFile == null
                          ? "Resim Seç"
                          : "Resmi Değiştir/Kaldır",
                    ),
                    onPressed:
                        () => _showImageSourceActionSheet(
                          context,
                        ), // Dialogu açar
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            // --- ---
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items:
                  <String>[
                    'Teknoloji',
                    'Bilim',
                    'Gezi',
                    'Oyun',
                    'Yaşam',
                    'Eğitim',
                    'Eğlence',
                    'Yemek',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
            ),
            SizedBox(height: 15),

            SwitchListTile(
              title: Text("Yayına Al"),
              subtitle: Text(
                _isPublished
                    ? "Herkes görebilir"
                    : "Sadece taslak olarak kaydedilecek",
              ),
              value: _isPublished,
              onChanged: (value) {
                setState(() {
                  _isPublished = value;
                });
              },
              secondary: Icon(_isPublished ? Icons.public : Icons.lock_outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.grey),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton.icon(
              icon: Icon(Icons.save_alt),
              label: Text("Kaydet"),
              onPressed: _savePost, //  kaydetme fonksiyonunu çağırır
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
