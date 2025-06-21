import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// NewPostPage'i import et
import 'new_posts.dart';
// BlogDetailPage'i import et (eğer tıklanınca detay gösterilecekse)
// import 'main.dart'; // BlogDetailPage main.dart içindeyse

class BlogPostsPage extends StatefulWidget {
  @override
  _BlogPostsPageState createState() => _BlogPostsPageState();
}

class _BlogPostsPageState extends State<BlogPostsPage> {
  /* // Örnek blog yazısı verileri STATE İÇİNE ALINDI!
  // Map<String, String> -> Map<String, dynamic> (resim yolu vb. için)
  List<Map<String, dynamic>> blogPosts = [
    {
      "title": "Teknolojiye Dair Her Şey",
      "content": "Yeni çıkan trendler...",
      "author": "Ben", // Yazar eklendi
      "category": "Teknoloji", // Kategori eklendi
      "imagePath": null,
    },
    {
      "title": "Seyahat Notlarım",
      "content": "Dünyayı gezerken yaşadıklarım...",
      "author": "Ben",
      "category": "Gezi",
      "imagePath": null,
    },
    {
      "title": "Kodlama ve Yazılım",
      "content": "Flutter ile geliştirme...",
      "author": "Ben",
      "category": "Teknoloji",
      "imagePath": null,
    },
  ];
*/
  List<Map<String, dynamic>> blogPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .get();

    setState(() {
      blogPosts =
          snapshot.docs.map((d) {
            final data = d.data();
            data['id'] = d.id;
            return data;
          }).toList();
    });
  }

  // Yeni yazı ekleme fonksiyonu
  void _navigateToNewPostPage() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => NewPostPage()),
    );

    // Eğer bir sonuç döndüyse (kullanıcı kaydetti ve geri döndü)
    if (result != null) {
      /*    // Normalde burada sadece o kullanıcıya ait gönderileri filtrelemek gerekir.
      // Şimdilik gelen her yeni gönderiyi ekliyoruz.
      setState(() {
        blogPosts.add(result);
      }); */
      await _fetchPosts();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("'${result['title']}' başarıyla eklendi!"),
            backgroundColor: Colors.green,
          ),
        );
    }
  }
  // --- ---

  void _deletePost(int index) {
    // Silme onayı
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            //AlertDialog uyarı mesajı verir
            title: Text("Emin misiniz?"),
            content: Text(
              "'${blogPosts[index]['title']}' başlıklı yazıyı silmek istediğinize emin misiniz?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false), // İptal
                child: Text("İptal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx, true); // Sil
                },
                child: Text("Sil", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    ).then((confirmed) async {
      if (confirmed == true) {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        final postId = blogPosts[index]['id'];
        if (userId != null && postId != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('posts')
              .doc(postId)
              .delete();
        }
        setState(() {
          final removedTitle = blogPosts[index]['title'];
          blogPosts.removeAt(index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("'$removedTitle' silindi."),
              backgroundColor: Colors.orange,
            ),
          );
        });
      }
    });
  }

  void _editPost(int index) {
    // Mevcut verileri al
    final currentPost = blogPosts[index]; //Düzenlenecek yazıyı alır
    TextEditingController titleController = TextEditingController(
      text: currentPost['title']?.toString() ?? '',
    ); //	Başlık alanına mevcut başlığı yükler
    TextEditingController contentController = TextEditingController(
      text: currentPost['content']?.toString() ?? '',
    ); //İçerik alanına mevcut içeriği yükler

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Yazıyı Düzenle"),
          content: SingleChildScrollView(
            // İçerik sığmazsa kaydırılabilir yap
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Başlık"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: "İçerik"),
                  maxLines: 5, // Daha fazla satır göster
                  minLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // İptal et
              },
              child: Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                // Değişiklikleri kontrol et (isteğe bağlı)
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  final postId = blogPosts[index]['id'];
                  if (userId != null && postId != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('posts')
                        .doc(postId)
                        .update({
                          'title': titleController.text,
                          'content': contentController.text,
                        });
                  }
                  setState(() {
                    blogPosts[index]['title'] = titleController.text;
                    blogPosts[index]['content'] = contentController.text;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Yazı güncellendi."),
                      backgroundColor: Colors.blue,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Başlık ve içerik boş olamaz."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yazılarım"),
        // Tema'dan farklı bir renk isterseniz:
        // backgroundColor: Colors.deepPurple,
        // foregroundColor: Colors.white,
      ),
      body:
          blogPosts
                  .isEmpty // Liste boşsa mesaj göster
              ? Center(
                child: Text(
                  "Henüz hiç yazı eklemediniz.\nEklemek için + butonuna dokunun.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
              : ListView.builder(
                // Liste doluysa ListView göster
                itemCount: blogPosts.length,
                itemBuilder: (context, index) {
                  final post = blogPosts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(
                        Icons.edit_note,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        post['title']?.toString() ?? 'Başlık Yok',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        post['content']?.toString() ?? 'İçerik Yok',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        // Düzenle ve Sil ikonları için Row
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                              size: 20,
                            ),
                            tooltip: "Düzenle",
                            onPressed: () => _editPost(index),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            tooltip: "Sil",
                            onPressed: () => _deletePost(index),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.open_in_new,
                                    color: Colors.green,
                                  ),
                                  title: Text("Detayları Gör"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Detay sayfası açılıyor... (Kod eklenmeli)",
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.edit, color: Colors.blue),
                                  title: Text("Düzenle"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _editPost(index);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: Text("Sil"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _deletePost(index);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
      //YENİ YAZI EKLEME
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewPostPage, // Yeni fonksiyonu çağır
        tooltip: 'Yeni Yazı Ekle',
        child: Icon(Icons.add_comment),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
