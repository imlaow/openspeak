import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../../core/models/chat_message.dart';
import '../../../core/models/conversation.dart';
import '../../../core/models/scenario.dart';
import '../../../core/services/chat_ai_service.dart';
import '../../../core/services/grammar_check_service.dart';
import '../../../core/services/stt_service.dart';
import '../../../core/services/tts_service.dart';

/// Coordinates AI chat, grammar checking, TTS, and STT services.
class ChatRepository {
  final ChatAIService _chatAI;
  final GrammarCheckService _grammarCheck;
  final TTSService _tts;
  final STTService _stt;
  final _uuid = const Uuid();

  ChatRepository({
    required ChatAIService chatAI,
    required GrammarCheckService grammarCheck,
    required TTSService tts,
    required STTService stt,
  })  : _chatAI = chatAI,
        _grammarCheck = grammarCheck,
        _tts = tts,
        _stt = stt;

  /// Creates a new conversation for the given scenario.
  Conversation createConversation(Scenario scenario) {
    final now = DateTime.now();
    return Conversation(
      id: _uuid.v4(),
      scenarioId: scenario.id,
      scenarioTitle: scenario.title,
      messages: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Sends a user message and returns an updated conversation with AI response.
  /// Grammar checking runs in parallel with the AI call.
  Future<Conversation> sendMessage(
    Conversation conversation,
    String userText,
    Scenario scenario,
  ) async {
    final userMsg = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: userText,
      timestamp: DateTime.now(),
    );

    // Run grammar check and AI in parallel
    final results = await Future.wait([
      _grammarCheck.checkGrammar(userText),
      _chatAI.sendMessage(
        history: conversation.messages,
        userMessage: userText,
        systemPrompt: scenario.systemPrompt,
      ),
    ]);

    final grammarFeedback = results[0] as GrammarFeedback?;
    final aiResponse = results[1] as String;

    final userMsgWithFeedback = grammarFeedback != null
        ? userMsg.copyWith(grammarFeedback: grammarFeedback)
        : userMsg;

    final aiMsg = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.assistant,
      content: aiResponse,
      timestamp: DateTime.now(),
    );

    return conversation.copyWith(
      messages: [...conversation.messages, userMsgWithFeedback, aiMsg],
      updatedAt: DateTime.now(),
    );
  }

  /// Streams the AI response, yielding partial content tokens.
  Stream<String> streamAIResponse(
    List<ChatMessage> history,
    String userMessage,
    String systemPrompt,
  ) {
    return _chatAI.sendMessageStream(
      history: history,
      userMessage: userMessage,
      systemPrompt: systemPrompt,
    );
  }

  /// Check grammar for a given text.
  Future<GrammarFeedback?> checkGrammar(String text) {
    return _grammarCheck.checkGrammar(text);
  }

  /// Start speech recognition.
  Stream<STTResult> startListening() {
    return _stt.startListening();
  }

  /// Stop speech recognition.
  Future<void> stopListening() => _stt.stopListening();

  /// Whether STT is currently active.
  bool get isListening => _stt.isListening;

  /// Synthesize text to speech audio.
  Future<dynamic> synthesizeSpeech(String text, {String? voiceName}) {
    return _tts.synthesize(text, voiceName: voiceName);
  }
}
