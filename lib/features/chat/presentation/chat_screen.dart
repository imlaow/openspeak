import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/scenario.dart';
import '../../chat/domain/providers.dart';
import '../domain/chat_notifier.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/streaming_bubble.dart';
import 'widgets/typing_indicator.dart';
import 'widgets/voice_input_bar.dart';

/// Main chat conversation screen.
class ChatScreen extends ConsumerStatefulWidget {
  final Scenario scenario;
  final bool showBackButton;
  final List<Widget> appBarActions;

  const ChatScreen({
    super.key,
    required this.scenario,
    this.showBackButton = true,
    this.appBarActions = const [],
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();
  late final ChatNotifier _chatNotifier;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(chatRepositoryProvider);
    _chatNotifier = ChatNotifier(repo, widget.scenario);
    _chatNotifier.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    _scrollToBottom();
  }

  @override
  void dispose() {
    _chatNotifier.removeListener(_onStateChanged);
    _chatNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        automaticallyImplyLeading: widget.showBackButton,
        title: Column(
          children: [
            Text(
              widget.scenario.title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.scenario.difficulty.label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        leading: widget.showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: colorScheme.onSurface,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: widget.appBarActions,
      ),
      body: ValueListenableBuilder<ChatState>(
        valueListenable: _chatNotifier,
        builder: (context, chatState, child) {
          return Column(
            children: [
              // Scenario info header
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.scenario.iconData,
                      size: 20,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.scenario.description,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Messages list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount:
                      chatState.messages.length +
                      (chatState.streamingAIText.isNotEmpty ? 1 : 0) +
                      (chatState.isAIResponding &&
                              chatState.streamingAIText.isEmpty
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (index < chatState.messages.length) {
                      return ChatBubble(message: chatState.messages[index]);
                    }
                    if (chatState.isAIResponding &&
                        chatState.streamingAIText.isEmpty &&
                        index == chatState.messages.length) {
                      return const TypingIndicator();
                    }
                    if (chatState.streamingAIText.isNotEmpty) {
                      return StreamingBubble(text: chatState.streamingAIText);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Voice input bar
              VoiceInputBar(
                isListening: chatState.isListening,
                isAIResponding: chatState.isAIResponding,
                partialText: chatState.partialSTTText,
                onMicPressed: () {
                  if (chatState.isListening) {
                    _chatNotifier.stopListening();
                    _chatNotifier.sendSTTResult();
                  } else {
                    _chatNotifier.startListening();
                  }
                },
                onSendPressed: () {
                  _chatNotifier.stopListening();
                  _chatNotifier.sendSTTResult();
                },
                onTextSubmitted: (text) {
                  _chatNotifier.sendMessage(text);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
