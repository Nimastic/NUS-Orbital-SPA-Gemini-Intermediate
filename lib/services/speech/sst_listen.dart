import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SstListen {
  static final _speech = SpeechToText();

  static Future<bool> startListening({
    required Function(String text) onResult,
    required ValueChanged<bool> onListening
  }) async {
    final isAvailable = await _speech.initialize(
      onStatus: (status) => onListening(_speech.isListening),
      onError: (e) => throw e
    );

    if (isAvailable) {
      _speech.listen(onResult: (value) => onResult(value.recognizedWords));
    }

    if (_speech.isListening) {
      stopListening(onListening: onListening);
      return true;
    }

    return isAvailable;
  }

  static void stopListening({
    required ValueChanged<bool> onListening
  }) {
    _speech.stop();
    onListening(_speech.isListening);
  }
}