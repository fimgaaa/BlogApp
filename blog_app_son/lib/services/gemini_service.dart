import 'package:google_generative_ai/google_generative_ai.dart';

import 'gemini_api_key.dart';

class GeminiService {
  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro', // ✅ AI Studio key ile çalışır
      apiKey: geminiApiKey,
    );
  }

  late final GenerativeModel _model;

  Future<List<String>> suggestTopics(String input) async {
    final prompt = 'Konu önerileri üret: $input';
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      return text.split('\n').where((e) => e.trim().isNotEmpty).toList();
    } catch (e) {
      print('Gemini HATA (suggestTopics): $e');
      return ['Hata oluştu: $e'];
    }
  }

  Future<Map<String, String>> generateTitleIntroOutro(String topic) async {
    final prompt =
        '"$topic" konusunda etkileyici bir başlık, giriş cümlesi ve kapanış cümlesi üret. '
        'Format:\nTitle: ...\nIntroduction: ...\nConclusion: ...';
    final result = <String, String>{};

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';

      for (var line in text.split('\n')) {
        if (line.toLowerCase().startsWith('title:')) {
          final parts = line.split(':');
          if (parts.length > 1) {
            result['title'] = parts.sublist(1).join(':').trim();
          }
        } else if (line.toLowerCase().startsWith('introduction:')) {
          final parts = line.split(':');
          if (parts.length > 1) {
            result['introduction'] = parts.sublist(1).join(':').trim();
          }
        } else if (line.toLowerCase().startsWith('conclusion:')) {
          final parts = line.split(':');
          if (parts.length > 1) {
            result['conclusion'] = parts.sublist(1).join(':').trim();
          }
        }
      }

      return result;
    } catch (e) {
      print('Gemini HATA (generateTitleIntroOutro): $e');
      return {'title': 'Hata oluştu', 'introduction': '', 'conclusion': ''};
    }
  }

  Future<String> summarizeText(String text) async {
    final prompt = 'Şu metni özetle:\n$text';
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Boş yanıt';
    } catch (e) {
      print("Gemini HATA (summarizeText): $e");
      return 'Hata oluştu: $e';
    }
  }

  Future<String> suggestTone(String text) async {
    final prompt =
        'Bu yazı için uygun yazım tonlarını öner (örnek: esprili, ciddi):\n$text';
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Boş yanıt';
    } catch (e) {
      print("Gemini HATA (suggestTone): $e");
      return 'Hata oluştu: $e';
    }
  }
}
