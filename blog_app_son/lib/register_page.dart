import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Ana widget: RegisterPage adında bir StatefulWidget (durum tutar).
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

// Widget'ın state sınıfı (durumu burada yönetiyoruz).
class _RegisterPageState extends State<RegisterPage> {
  // Kullanıcıdan alınacak veriler için controller'lar
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isRegistering =
      false; // Kayıt işlemi sırasında loading animasyonu için kontrol

  //void _register() {
  Future<void> _register() async {
    // Şifrelerin eşleşip eşleşmediğini kontrol et
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Şifreler eşleşmiyor')));
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    try {
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      final user = credential.user;
      if (user != null) {
        final avatarUrl =
            'https://api.dicebear.com/6.x/initials/png?seed=${user.uid}';
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'imageUrl': avatarUrl,
          'joinedDate': DateTime.now().toIso8601String(),
        });
      }
      // Başarı mesajı göster
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kayıt başarılı 🎉')));

      // Login sayfasına geri dön
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Bir hata oluştu')));
    } finally {
      if (mounted) {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka planı tamamen kaplamak için Container kullanıyoruz
      body: Container(
        width: double.infinity,
        height: double.infinity, // 👈 Ekranı tamamen kapla
        decoration: BoxDecoration(
          // Degrade renk geçişli arka plan
          gradient: LinearGradient(
            colors: [Colors.pink.shade200, Colors.orange.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                // Başlık
                Text(
                  "👋 Hoş Geldin!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Hemen üye ol, eğlenceye katıl!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
                SizedBox(height: 30),

                // Email input alanı
                _buildTextField(
                  controller: _emailController,
                  label: "📧 Email",
                  hint: "ornek@mail.com",
                  icon: Icons.mail_outline,
                ),
                SizedBox(height: 15),

                // Şifre input alanı
                _buildTextField(
                  controller: _passwordController,
                  label: "🔒 Şifre",
                  hint: "En az 6 karakter",
                  obscure: true,
                  icon: Icons.lock_outline,
                ),
                SizedBox(height: 15),

                // Şifre tekrar input alanı
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: "🔒 Şifre (Tekrar)",
                  hint: "Şifrenizi tekrar girin",
                  obscure: true,
                  icon: Icons.lock_outline,
                ),
                SizedBox(height: 30),

                // Kayıt butonu
                ElevatedButton(
                  onPressed: _isRegistering ? null : _register,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:
                      _isRegistering
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "🎉 Kayıt Ol",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Ortak input alanı oluşturan yardımcı fonksiyon
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        prefixIcon: Icon(icon, color: Colors.purple),
      ),
    );
  }
}
