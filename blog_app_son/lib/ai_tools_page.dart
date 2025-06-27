import 'package:flutter/material.dart';

import 'services/gemini_service.dart';

class AiToolsPage extends StatefulWidget {
  const AiToolsPage({super.key});

  @override
  State<AiToolsPage> createState() => _AiToolsPageState();
}

class _AiToolsPageState extends State<AiToolsPage> {
  final TextEditingController _inputController = TextEditingController();
  final GeminiService _service = GeminiService();

  String _result = '';
  bool _loading = false;

  Future<void> _run(Future<String> Function() action) async {
    setState(() {
      _loading = true;
      _result = '';
    });
    try {
      final r = await action();
      setState(() {
        _result = r;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Yardımcısı')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Metin veya konu',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed:
                      () => _run(() async {
                        final topics = await _service.suggestTopics(
                          _inputController.text,
                        );
                        return topics.join('\n');
                      }),
                  child: const Text('Konu Öner'),
                ),
                ElevatedButton(
                  onPressed:
                      () => _run(() async {
                        final result = await _service.generateTitleIntroOutro(
                          _inputController.text,
                        );
                        return 'Başlık: ${result['title'] ?? ''}\n\nGiriş: ${result['introduction'] ?? ''}\n\nKapanış: ${result['conclusion'] ?? ''}';
                      }),
                  child: const Text('Başlık/Giriş/Kapanış'),
                ),
                ElevatedButton(
                  onPressed:
                      () => _run(
                        () => _service.summarizeText(_inputController.text),
                      ),
                  child: const Text('Özetle'),
                ),
                ElevatedButton(
                  onPressed:
                      () => _run(
                        () => _service.suggestTone(_inputController.text),
                      ),
                  child: const Text('Ton Öner'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading)
              Expanded(
                child: SingleChildScrollView(child: SelectableText(_result)),
              ),
          ],
        ),
      ),
    );
  }
}
