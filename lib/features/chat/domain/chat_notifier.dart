import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/chat_message.dart';
import '../../../core/models/conversation.dart';
import '../../../core/models/scenario.dart';
import '../../../core/services/stt_service.dart';
import 'providers.dart';

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

/// Manages the chat conversation state using Riverpod Notifier.
class ChatNotifier extends FamilyNotifier<ChatState, Scenario> {
  StreamSubscription<STTResult>? _sttSubscription;
  final _uuid = const Uuid();
  late final Scenario _scenario;

  @override
  ChatState build(Scenario arg) {
    _scenario = arg;
    ref.onDispose(() {
      _sttSubscription?.cancel();
    });
    return _buildInitialState();
  }

  ChatState _buildInitialState() {
    final repo = ref.read(chatRepositoryProvider);
    final conversation = repo.createConversation(_scenario);

    final greeting = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.assistant,
      content: _getGreeting(),
      timestamp: DateTime.now(),
    );

    return ChatState(
      conversation: conversation.copyWith(messages: [greeting]),
    );
  }

  String _getGreeting() {
    switch (_scenario.id) {
      case 'daily_coffee_shop':
        return "Hey there! Welcome to The Daily Grind ☕ What can I get started for you today?";
      case 'daily_grocery':
        return "Hi! Welcome to FreshMart. Can I help you find anything today?";
      case 'daily_roommate':
        return "Hey roomie! So, we need to talk about this weekend's plans. Are you free Saturday?";
      case 'biz_interview':
        return "Good morning! Thank you for coming in today. Please, have a seat. Let's start — could you tell me a little about yourself?";
      case 'biz_meeting':
        return "Alright everyone, let's get started with our weekly sync. Who wants to go first with their update?";
      case 'biz_email':
        return "Hi! I'm here to help you write professional emails. What kind of email do you need to draft today?";
      case 'travel_airport':
        return "Good morning! Welcome to check-in. May I see your passport and booking confirmation, please?";
      case 'travel_hotel':
        return "Welcome to the Grand Plaza Hotel! Do you have a reservation with us?";
      case 'travel_directions':
        return "Oh, you look a bit lost! Are you looking for something nearby? I can help you with directions.";
      case 'academic_presentation':
        return "Alright class, our next presentation is ready. Please go ahead — we're all listening. What's your topic today?";
      case 'academic_study_group':
        return "Hey! Glad you could make it to study group. So, which chapter should we tackle first for the exam?";
      case 'academic_office_hours':
        return "Come in! Please have a seat. What questions do you have about the course material?";
      default:
        return "Hello! Let's practice some English together. What would you like to talk about?";
    }
  }

  /// Send a text message from the user.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.isAIResponding) return;

    final repo = ref.read(chatRepositoryProvider);
    final conversation = state.conversation;
    if (conversation == null) return;

    // Add user message immediately
    final userMsg = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: text.trim(),
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      conversation: conversation.copyWith(
        messages: [...conversation.messages, userMsg],
      ),
      isAIResponding: true,
      streamingAIText: '',
      partialSTTText: '',
    );

    try {
      // Start grammar check in background
      final grammarFuture = repo.checkGrammar(text.trim());

      // Stream AI response
      final aiMsgId = _uuid.v4();
      final buffer = StringBuffer();

      await for (final token in repo.streamAIResponse(
        state.messages,
        text.trim(),
        _scenario.systemPrompt,
      )) {
        buffer.write(token);
        state = state.copyWith(streamingAIText: buffer.toString());
      }

      // Get grammar result
      final grammarFeedback = await grammarFuture;

      // Update user message with grammar feedback
      final updatedMessages = state.messages.map((m) {
        if (m.id == userMsg.id && grammarFeedback != null) {
          return m.copyWith(grammarFeedback: grammarFeedback);
        }
        return m;
      }).toList();

      // Add final AI message
      final aiMsg = ChatMessage(
        id: aiMsgId,
        role: MessageRole.assistant,
        content: buffer.toString(),
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        conversation: state.conversation?.copyWith(
          messages: [...updatedMessages, aiMsg],
          updatedAt: DateTime.now(),
        ),
        isAIResponding: false,
        streamingAIText: '',
      );
    } catch (e) {
      state = state.copyWith(
        isAIResponding: false,
        error: e.toString(),
      );
    }
  }

  /// Start speech recognition.
  void startListening() {
    final repo = ref.read(chatRepositoryProvider);

    state = state.copyWith(
      isListening: true,
      partialSTTText: '',
    );

    _sttSubscription = repo.startListening().listen(
      (result) {
        state = state.copyWith(partialSTTText: result.text);

        if (result.isFinal) {
          stopListening();
        }
      },
      onError: (e) {
        state = state.copyWith(
          isListening: false,
          error: e.toString(),
        );
      },
    );
  }

  /// Stop speech recognition.
  Future<void> stopListening() async {
    await _sttSubscription?.cancel();
    _sttSubscription = null;

    final repo = ref.read(chatRepositoryProvider);
    await repo.stopListening();

    state = state.copyWith(isListening: false);
  }

  /// Send whatever partial STT text we have.
  void sendSTTResult() {
    final text = state.partialSTTText;
    if (text.isNotEmpty) {
      sendMessage(text);
    }
  }
}

/// Provider family: one chat notifier per scenario.
final chatNotifierProvider =
    NotifierProvider.family<ChatNotifier, ChatState, Scenario>(
  ChatNotifier.new,
);
