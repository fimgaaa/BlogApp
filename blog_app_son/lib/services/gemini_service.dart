import 'package:google_generative_ai/google_generative_ai.dart';

import 'gemini_api_key.dart';

class GeminiService {
  GeminiService() {
    _model = GenerativeModel(model: 'gemini-pro', apiKey: geminiApiKey);
  }

  late final GenerativeModel _model;

  Future<List<String>> suggestTopics(String input) async {
    final prompt = 'Konu önerileri üret: $input';
    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '';
    return text.split('\n').where((e) => e.trim().isNotEmpty).toList();
  }

  Future<Map<String, String>> generateTitleIntroOutro(String topic) async {
    final prompt =
        '"$topic" konusunda etkileyici bir başlık, giriş cümlesi ve kapanış cümlesi üret. '
        'Format:\nTitle: ...\nIntroduction: ...\nConclusion: ...';
    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '';
    final result = <String, String>{};
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
  }

  Future<String> summarizeText(String text) async {
    final prompt = 'Şu metni özetle:\n$text';
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }

  Future<String> suggestTone(String text) async {
    final prompt =
        'Bu yazı için uygun yazım tonlarını öner (örnek: esprili, ciddi):\n$text';
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }
}
