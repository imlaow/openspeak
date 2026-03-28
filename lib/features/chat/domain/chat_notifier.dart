import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/chat_message.dart';
import '../../../core/models/conversation.dart';
import '../../../core/models/scenario.dart';
import '../../../core/services/stt_service.dart';
import '../data/chat_repository.dart';

/// State for the chat screen.
class ChatState {
  final Conversation? conversation;
  final bool isAIResponding;
  final bool isListening;
  final String partialSTTText;
  final String streamingAIText;
  final String? error;

  const ChatState({
    this.conversation,
    this.isAIResponding = false,
    this.isListening = false,
    this.partialSTTText = '',
    this.streamingAIText = '',
    this.error,
  });

  ChatState copyWith({
    Conversation? conversation,
    bool? isAIResponding,
    bool? isListening,
    String? partialSTTText,
    String? streamingAIText,
    String? error,
  }) {
    return ChatState(
      conversation: conversation ?? this.conversation,
      isAIResponding: isAIResponding ?? this.isAIResponding,
      isListening: isListening ?? this.isListening,
      partialSTTText: partialSTTText ?? this.partialSTTText,
      streamingAIText: streamingAIText ?? this.streamingAIText,
      error: error,
    );
  }

  List<ChatMessage> get messages => conversation?.messages ?? [];
}

/// Manages the chat conversation state using ValueNotifier.
class ChatNotifier extends ValueNotifier<ChatState> {
  final ChatRepository _repo;
  final Scenario scenario;
  StreamSubscription<STTResult>? _sttSubscription;
  final _uuid = const Uuid();

  ChatNotifier(this._repo, this.scenario) : super(const ChatState()) {
    _initConversation();
  }

  void _initConversation() {
    final conversation = _repo.createConversation(scenario);
    final greeting = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.assistant,
      content: _getGreeting(),
      timestamp: DateTime.now(),
    );
    value = value.copyWith(
      conversation: conversation.copyWith(messages: [greeting]),
    );
  }

  String _getGreeting() {
    const greetings = {
      'daily_coffee_shop':
          "Hey there! Welcome to The Daily Grind ☕ What can I get started for you today?",
      'daily_grocery':
          "Hi! Welcome to FreshMart. Can I help you find anything today?",
      'daily_roommate':
          "Hey roomie! So, we need to talk about this weekend's plans. Are you free Saturday?",
      'biz_interview':
          "Good morning! Thank you for coming in today. Please, have a seat. Let's start — could you tell me a little about yourself?",
      'biz_meeting':
          "Alright everyone, let's get started with our weekly sync. Who wants to go first with their update?",
      'biz_email':
          "Hi! I'm here to help you write professional emails. What kind of email do you need to draft today?",
      'travel_airport':
          "Good morning! Welcome to check-in. May I see your passport and booking confirmation, please?",
      'travel_hotel':
          "Welcome to the Grand Plaza Hotel! Do you have a reservation with us?",
      'travel_directions':
          "Oh, you look a bit lost! Are you looking for something nearby? I can help you with directions.",
      'academic_presentation':
          "Alright class, our next presentation is ready. Please go ahead — we're all listening. What's your topic today?",
      'academic_study_group':
          "Hey! Glad you could make it to study group. So, which chapter should we tackle first for the exam?",
      'academic_office_hours':
          "Come in! Please have a seat. What questions do you have about the course material?",
    };
    return greetings[scenario.id] ??
        "Hello! Let's practice some English together. What would you like to talk about?";
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || value.isAIResponding) return;

    final conversation = value.conversation;
    if (conversation == null) return;

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: text.trim(),
      timestamp: DateTime.now(),
    );

    value = value.copyWith(
      conversation: conversation.copyWith(
        messages: [...conversation.messages, userMsg],
      ),
      isAIResponding: true,
      streamingAIText: '',
      partialSTTText: '',
    );

    try {
      final grammarFuture = _repo.checkGrammar(text.trim());
      final aiMsgId = _uuid.v4();
      final buffer = StringBuffer();

      await for (final token in _repo.streamAIResponse(
        value.messages,
        text.trim(),
        scenario.systemPrompt,
      )) {
        buffer.write(token);
        value = value.copyWith(streamingAIText: buffer.toString());
      }

      final grammarFeedback = await grammarFuture;
      final updatedMessages = value.messages.map((m) {
        if (m.id == userMsg.id && grammarFeedback != null) {
          return m.copyWith(grammarFeedback: grammarFeedback);
        }
        return m;
      }).toList();

      final aiMsg = ChatMessage(
        id: aiMsgId,
        role: MessageRole.assistant,
        content: buffer.toString(),
        timestamp: DateTime.now(),
      );

      value = value.copyWith(
        conversation: value.conversation?.copyWith(
          messages: [...updatedMessages, aiMsg],
          updatedAt: DateTime.now(),
        ),
        isAIResponding: false,
        streamingAIText: '',
      );
    } catch (e) {
      value = value.copyWith(isAIResponding: false, error: e.toString());
    }
  }

  void startListening() {
    value = value.copyWith(isListening: true, partialSTTText: '');

    _sttSubscription = _repo.startListening().listen(
      (result) {
        value = value.copyWith(partialSTTText: result.text);
        if (result.isFinal) stopListening();
      },
      onError: (e) {
        value = value.copyWith(isListening: false, error: e.toString());
      },
    );
  }

  Future<void> stopListening() async {
    await _sttSubscription?.cancel();
    _sttSubscription = null;
    await _repo.stopListening();
    value = value.copyWith(isListening: false);
  }

  void sendSTTResult() {
    final text = value.partialSTTText;
    if (text.isNotEmpty) sendMessage(text);
  }

  @override
  void dispose() {
    _sttSubscription?.cancel();
    super.dispose();
  }
}
