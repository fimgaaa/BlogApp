abstract class IVoiceRecognizer {
  /// Initialize the recognizer. Returns true if initialization succeeded.
  Future<bool> initialize();

  /// Start listening and invoke [onResult] with recognized text and a flag
  /// indicating whether the result is final.
  void listen({required void Function(String text, bool finalResult) onResult});

  /// Stop listening.
  void stop();
}
