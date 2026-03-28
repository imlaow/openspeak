/// Represents a single message in a conversation.
class ChatMessage {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final GrammarFeedback? grammarFeedback;
  final PronunciationFeedback? pronunciationFeedback;
  final bool isStreaming;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.grammarFeedback,
    this.pronunciationFeedback,
    this.isStreaming = false,
  });

  ChatMessage copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    GrammarFeedback? grammarFeedback,
    PronunciationFeedback? pronunciationFeedback,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      grammarFeedback: grammarFeedback ?? this.grammarFeedback,
      pronunciationFeedback:
          pronunciationFeedback ?? this.pronunciationFeedback,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

enum MessageRole { user, assistant, system }

/// Grammar feedback attached to a user message.
class GrammarFeedback {
  final String originalText;
  final String correctedText;
  final List<GrammarError> errors;

  const GrammarFeedback({
    required this.originalText,
    required this.correctedText,
    required this.errors,
  });
}

class GrammarError {
  final String errorText;
  final String correction;
  final String explanation;

  const GrammarError({
    required this.errorText,
    required this.correction,
    required this.explanation,
  });
}

/// Pronunciation feedback from Azure Speech Assessment.
class PronunciationFeedback {
  final double accuracyScore;
  final double fluencyScore;
  final double completenessScore;
  final double prosodyScore;
  final List<WordScore> words;

  const PronunciationFeedback({
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.prosodyScore,
    required this.words,
  });

  double get overallScore =>
      (accuracyScore + fluencyScore + completenessScore + prosodyScore) / 4;
}

class WordScore {
  final String word;
  final double accuracyScore;
  final String errorType; // 'None', 'Mispronunciation', 'Omission', 'Insertion'

  const WordScore({
    required this.word,
    required this.accuracyScore,
    required this.errorType,
  });
}
