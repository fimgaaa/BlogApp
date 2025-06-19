import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Formu doğrulamak için key
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose(); // Controller'ı temizle
    super.dispose();
  }

  // Şifre sıfırlama işlemini simüle eden fonksiyon
  Future<void> _resetPassword() async {
    // Form geçerli mi kontrol et
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Yükleniyor durumunu başlat
      });

      // E-posta adresini al
      String email = _emailController.text.trim();
      print("Şifre sıfırlama isteği gönderiliyor: $email");

      // Simülasyon için 2 saniye bekle
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false; // Yükleniyor durumunu bitir
      });

      // Kullanıcıya geri bildirim ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '$email adresine şifre sıfırlama bağlantısı gönderildi (eğer kayıtlıysa).'),
          backgroundColor: Colors.green,
        ),
      );

      // İsteğe bağlı: Kullanıcıyı giriş sayfasına geri yönlendir
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🔑 Şifremi Unuttum"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.pinkAccent.shade100.withOpacity(0.5)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            // Klavye açıldığında taşmayı önlemek için koydum
            padding: EdgeInsets.all(20.0),
            child: Form(
              // E-posta doğrulaması için widget'ı
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Butonu genişletir
                children: [
                  Icon(
                    Icons.lock_reset, // Sıfırlama ikonu
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Şifrenizi sıfırlamak için lütfen kayıtlı e-posta adresinizi girin.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "📧 E-posta Adresi",
                      hintText: "ornek@eposta.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Icon(Icons.email_outlined),
                      fillColor: Colors.white.withOpacity(0.8),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen e-posta adresinizi girin.';
                      }
                      // Basit e-posta format kontrolü
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Lütfen geçerli bir e-posta adresi girin.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _resetPassword, // Yükleniyorsa butonu devre dışı bırak
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Arka plan rengi
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            // Yüklenirken dönen ikon göster
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            "🚀 Sıfırlama Linki Gönder",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
