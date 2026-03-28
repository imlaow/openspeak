import 'dart:async';

/// Abstract interface for Speech-to-Text services (Azure Speech).
abstract class STTService {
  /// Start real-time speech recognition.
  /// Returns a stream of recognized text (partial + final results).
  Stream<STTResult> startListening({String language = 'en-US'});

  /// Stop listening.
  Future<void> stopListening();

  /// Whether the service is currently listening.
  bool get isListening;
}

/// Result from speech recognition.
class STTResult {
  final String text;
  final bool isFinal;
  final double confidence;

  const STTResult({
    required this.text,
    required this.isFinal,
    this.confidence = 1.0,
  });
}

/// Mock STT that simulates speech recognition.
class MockSTTService implements STTService {
  bool _isListening = false;
  StreamController<STTResult>? _controller;

  static const _mockPhrases = [
    'I went to the park yesterday',
    'She has been studying English for two years',
    'Could you please tell me where the nearest station is',
    'I would like to order a cappuccino please',
    'The weather has been really nice this week',
    'I think learning English is very important for my career',
    'If I had more free time I would read more books',
    'I have been working on this project since last month',
  ];

  int _phraseIndex = 0;

  @override
  Stream<STTResult> startListening({String language = 'en-US'}) {
    _isListening = true;
    _controller = StreamController<STTResult>();

    _simulateRecognition();

    return _controller!.stream;
  }

  Future<void> _simulateRecognition() async {
    final phrase = _mockPhrases[_phraseIndex % _mockPhrases.length];
    _phraseIndex++;

    final words = phrase.split(' ');

    // Simulate partial results
    for (int i = 0; i < words.length && _isListening; i++) {
      await Future.delayed(const Duration(milliseconds: 350));
      if (!_isListening) break;

      final partial = words.sublist(0, i + 1).join(' ');
      _controller?.add(STTResult(
        text: partial,
        isFinal: false,
        confidence: 0.7 + (i / words.length) * 0.3,
      ));
    }

    // Final result
    if (_isListening) {
      await Future.delayed(const Duration(milliseconds: 200));
      _controller?.add(STTResult(
        text: phrase,
        isFinal: true,
        confidence: 0.95,
      ));
    }
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    await _controller?.close();
    _controller = null;
  }

  @override
  bool get isListening => _isListening;
}
