import 'chat_message.dart';

/// Represents an ongoing or completed conversation session.
class Conversation {
  final String id;
  final String scenarioId;
  final String scenarioTitle;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.scenarioId,
    required this.scenarioTitle,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  Conversation copyWith({
    String? id,
    String? scenarioId,
    String? scenarioTitle,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      scenarioId: scenarioId ?? this.scenarioId,
      scenarioTitle: scenarioTitle ?? this.scenarioTitle,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get messageCount => messages.length;

  int get userMessageCount =>
      messages.where((m) => m.role == MessageRole.user).length;
}
