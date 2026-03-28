import 'dart:async';
import 'dart:math';

import '../models/chat_message.dart';

/// Abstract interface for grammar checking (Cloudflare Workers AI).
abstract class GrammarCheckService {
  /// Checks grammar of the given text and returns feedback.
  Future<GrammarFeedback?> checkGrammar(String text);
}

/// Mock grammar checker that returns realistic-looking feedback.
class MockGrammarCheckService implements GrammarCheckService {
  final _random = Random();

  // Common English errors and their corrections
  static const _errorPatterns = [
    {
      'pattern': 'I am agree',
      'correction': 'I agree',
      'explanation':
          '"Agree" is a verb, not an adjective. Use "I agree" without "am."',
    },
    {
      'pattern': 'since three years',
      'correction': 'for three years',
      'explanation':
          'Use "for" with a duration of time, and "since" with a specific point in time.',
    },
    {
      'pattern': 'more better',
      'correction': 'better',
      'explanation':
          '"Better" is already the comparative form of "good." Do not add "more."',
    },
    {
      'pattern': 'informations',
      'correction': 'information',
      'explanation':
          '"Information" is an uncountable noun in English and does not take a plural form.',
    },
    {
      'pattern': 'I am liking',
      'correction': 'I like',
      'explanation':
          '"Like" is a stative verb and is not typically used in the continuous tense.',
    },
  ];

  @override
  Future<GrammarFeedback?> checkGrammar(String text) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // 40% chance of finding a "grammar error" in mock mode
    if (_random.nextDouble() > 0.4) return null;

    final errorTemplate =
        _errorPatterns[_random.nextInt(_errorPatterns.length)];

    return GrammarFeedback(
      originalText: text,
      correctedText: text, // In mock mode, we just flag the concept
      errors: [
        GrammarError(
          errorText: errorTemplate['pattern']!,
          correction: errorTemplate['correction']!,
          explanation: errorTemplate['explanation']!,
        ),
      ],
    );
  }
}
