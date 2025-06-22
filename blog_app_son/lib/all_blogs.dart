import 'package:blog_app_son/services/voice_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllBlogsPage extends StatefulWidget {
  @override
  _AllBlogsPageState createState() => _AllBlogsPageState();
}

class _AllBlogsPageState extends State<AllBlogsPage> {
  List<Map<String, dynamic>> blogPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collectionGroup('posts')
            .where('isPublished', isEqualTo: true)
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

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final filteredPosts =
        blogPosts
            .where(
              (post) =>
                  selectedCategory == null ||
                  post['category'] == selectedCategory,
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Tüm Blog Yazıları"),
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              VoiceService.instance.speak('Tüm Blog Yazıları');
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              VoiceService.instance.stop();
            },
          ),
          PopupMenuButton<String?>(
            icon: Icon(Icons.filter_list),
            tooltip: 'Kategoriye Göre Filtrele',
            onSelected: (String? value) {
              setState(() {
                selectedCategory = value;
              });
            },
            itemBuilder: (BuildContext context) {
              final categories = <String>[
                'Teknoloji',
                'Bilim',
                'Gezi',
                'Oyun',
                'Yaşam',
                'Eğitim',
                'Eğlence',
                'Yemek',
              ];
              categories.sort();
              List<PopupMenuEntry<String?>> menuItems = [];
              menuItems.add(
                PopupMenuItem<String?>(
                  value: null,
                  child: Text(
                    'Tümü',
                    style: TextStyle(
                      fontWeight:
                          selectedCategory == null
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                ),
              );
              menuItems.add(PopupMenuDivider());
              menuItems.addAll(
                categories
                    .map(
                      (category) => PopupMenuItem<String?>(
                        value: category,
                        child: Text(
                          category,
                          style: TextStyle(
                            fontWeight:
                                selectedCategory == category
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
              return menuItems;
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child:
            filteredPosts.isEmpty
                ? Center(
                  child: Text(
                    selectedCategory == null
                        ? "Henüz blog yazısı yok."
                        : "'$selectedCategory' kategorisinde yazı bulunamadı.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
                : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    final post = filteredPosts[index];
                    final imageUrl = post['imageUrl'] as String?;
                    // final imagePath = post['imagePath'] as String?;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlogDetailPage(post: post),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: Colors.grey[200],
                                /*       child:
                                    imagePath != null && imagePath.isNotEmpty
                                        ? Image.file(
                                          File(imagePath),
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: Colors.grey[500],
                                            );
                                          },
                                        )*/
                                child:
                                    imageUrl != null && imageUrl.isNotEmpty
                                        ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: Colors.grey[500],
                                            );
                                          },
                                        )
                                        : Icon(
                                          Icons.article_outlined,
                                          size: 50,
                                          color: Colors.grey[600],
                                        ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      post['title'] ?? 'Başlık Yok',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      post['author'] ?? 'Yazar Yok',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      post['category'] ?? 'Kategori Yok',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

class BlogDetailPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const BlogDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final imageUrl = post['imageUrl'] as String?;

    return Scaffold(
      //appBar: AppBar(title: Text(post['title'] ?? 'Blog Detayı')),
      appBar: AppBar(
        title: Text(post['title'] ?? 'Blog Detayı'),
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              VoiceService.instance.speak(post['content'] ?? '');
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'] ?? 'Başlık Bulunamadı',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey[700]),
                SizedBox(width: 4),
                Text(
                  post['author'] ?? 'Bilinmeyen Yazar',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 16),
                Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: Colors.grey[700],
                ),
                SizedBox(width: 4),
                Text(
                  post['category'] ?? 'Kategorisiz',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (imageUrl != null && imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                // child: Image.file(
                // File(imagePath),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey[500],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (imageUrl != null && imageUrl.isNotEmpty) SizedBox(height: 16),
            Divider(height: 24, thickness: 1),
            Text(
              post['content'] ?? 'İçerik yüklenemedi.',
              style: textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
