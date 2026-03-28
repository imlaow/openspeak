import 'dart:math';

import 'package:flutter/material.dart';

/// Bottom bar for voice input with mic button, waveform animation and text preview.
class VoiceInputBar extends StatelessWidget {
  final bool isListening;
  final bool isAIResponding;
  final String partialText;
  final VoidCallback onMicPressed;
  final VoidCallback onSendPressed;
  final ValueChanged<String> onTextSubmitted;

  const VoiceInputBar({
    super.key,
    required this.isListening,
    required this.isAIResponding,
    required this.partialText,
    required this.onMicPressed,
    required this.onSendPressed,
    required this.onTextSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Partial recognized text preview
              if (isListening && partialText.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    partialText,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

              // Waveform animation when listening
              if (isListening)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _WaveformAnimation(colorScheme: colorScheme),
                ),

              // Input row
              Row(
                children: [
                  // Text input field
                  Expanded(
                    child: _ChatTextField(
                      isListening: isListening,
                      isAIResponding: isAIResponding,
                      onSubmitted: onTextSubmitted,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Mic / Send button
                  if (isListening && partialText.isNotEmpty)
                    _SendButton(
                      onTap: onSendPressed,
                      colorScheme: colorScheme,
                    )
                  else
                    _MicButton(
                      isListening: isListening,
                      isDisabled: isAIResponding,
                      onTap: onMicPressed,
                      colorScheme: colorScheme,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatTextField extends StatefulWidget {
  final bool isListening;
  final bool isAIResponding;
  final ValueChanged<String> onSubmitted;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ChatTextField({
    required this.isListening,
    required this.isAIResponding,
    required this.onSubmitted,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  State<_ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<_ChatTextField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: !widget.isListening && !widget.isAIResponding,
      style: widget.textTheme.bodyLarge?.copyWith(
        color: widget.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: widget.isListening
            ? 'Listening...'
            : widget.isAIResponding
                ? 'AI is thinking...'
                : 'Type or tap mic to speak...',
        hintStyle: widget.textTheme.bodyLarge?.copyWith(
          color: widget.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        filled: true,
        fillColor: widget.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  widget.onSubmitted(_controller.text);
                  _controller.clear();
                  setState(() {});
                },
                icon: Icon(
                  Icons.send_rounded,
                  color: widget.colorScheme.primary,
                ),
              )
            : null,
      ),
      textInputAction: TextInputAction.send,
      onChanged: (_) => setState(() {}),
      onSubmitted: (text) {
        if (text.trim().isNotEmpty) {
          widget.onSubmitted(text);
          _controller.clear();
          setState(() {});
        }
      },
    );
  }
}

class _MicButton extends StatelessWidget {
  final bool isListening;
  final bool isDisabled;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _MicButton({
    required this.isListening,
    required this.isDisabled,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isListening ? 64 : 56,
        height: isListening ? 64 : 56,
        decoration: BoxDecoration(
          color: isListening
              ? colorScheme.error
              : isDisabled
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: isListening
              ? [
                  BoxShadow(
                    color: colorScheme.error.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Icon(
          isListening ? Icons.stop_rounded : Icons.mic_rounded,
          color: isListening
              ? colorScheme.onError
              : isDisabled
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onPrimary,
          size: 28,
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _SendButton({
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.send_rounded,
          color: colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }
}

class _WaveformAnimation extends StatefulWidget {
  final ColorScheme colorScheme;

  const _WaveformAnimation({required this.colorScheme});

  @override
  State<_WaveformAnimation> createState() => _WaveformAnimationState();
}

class _WaveformAnimationState extends State<_WaveformAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(20, (i) {
              final phase = (_controller.value * 2 * pi) + (i * 0.3);
              final height = 8 + sin(phase).abs() * 20;
              return Container(
                width: 3,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: widget.colorScheme.primary.withValues(
                    alpha: 0.4 + sin(phase).abs() * 0.6,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
