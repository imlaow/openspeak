import 'dart:async';

import '../models/chat_message.dart';

/// Abstract interface for chat AI services (Azure OpenAI GPT-4o).
abstract class ChatAIService {
  /// Sends a message and returns the AI response.
  Future<String> sendMessage({
    required List<ChatMessage> history,
    required String userMessage,
    required String systemPrompt,
  });

  /// Sends a message and streams the AI response token-by-token.
  Stream<String> sendMessageStream({
    required List<ChatMessage> history,
    required String userMessage,
    required String systemPrompt,
  });
}

/// Mock implementation that simulates AI responses for development.
class MockChatAIService implements ChatAIService {
  static const _mockResponses = [
    "That's a great sentence! I noticed you used the past tense correctly. Let me ask you a follow-up question: What did you do after that?",
    "Interesting! Your grammar is quite good. One small tip: try using 'would rather' instead of 'prefer to' in casual conversation. For example, 'I would rather have coffee than tea.' Can you try making a similar sentence?",
    "I like your enthusiasm! Let me help you with a more natural way to express that. Instead of saying 'I am very much liking it,' you could say 'I really like it' or 'I'm really enjoying it.' Present continuous with 'like' isn't common in English. Could you try again?",
    "That's perfectly said! Your pronunciation of the 'th' sound in 'through' is getting much better. Now, let's practice another tricky word. Can you say 'thoroughly' in a sentence?",
    "Good effort! Remember, in English we say 'I have been living here for three years,' not 'since three years.' The word 'for' is used with a duration of time, while 'since' is used with a specific point in time. Can you correct your sentence?",
    "Excellent vocabulary choice! Using 'magnificent' instead of just 'beautiful' really makes your English sound more advanced. Let's continue building your vocabulary. What other adjectives do you know that mean 'very good'?",
    "Great use of the conditional tense! 'If I had more time, I would travel the world' is a perfect example of the second conditional. Let me give you another scenario: What would you do if you won the lottery?",
    "That was a wonderful response! I especially liked how you used linking words like 'however' and 'moreover.' These really help connect your ideas smoothly. Shall we practice using more transition words?",
  ];

  int _responseIndex = 0;

  @override
  Future<String> sendMessage({
    required List<ChatMessage> history,
    required String userMessage,
    required String systemPrompt,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final response = _mockResponses[_responseIndex % _mockResponses.length];
    _responseIndex++;
    return response;
  }

  @override
  Stream<String> sendMessageStream({
    required List<ChatMessage> history,
    required String userMessage,
    required String systemPrompt,
  }) async* {
    await Future.delayed(const Duration(milliseconds: 500));
    final response = _mockResponses[_responseIndex % _mockResponses.length];
    _responseIndex++;

    // Simulate streaming word by word
    final words = response.split(' ');
    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 60));
      yield '${words[i]}${i < words.length - 1 ? ' ' : ''}';
    }
  }
}
