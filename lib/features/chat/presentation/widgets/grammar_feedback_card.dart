import 'package:flutter/material.dart';

import '../../../../core/models/chat_message.dart';

/// Expandable card showing grammar error corrections.
class GrammarFeedbackCard extends StatelessWidget {
  final GrammarFeedback feedback;

  const GrammarFeedbackCard({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_rounded,
                size: 18,
                color: colorScheme.onTertiaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'Grammar Tip',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...feedback.errors.map((error) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error → Correction
                    RichText(
                      text: TextSpan(
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onTertiaryContainer,
                        ),
                        children: [
                          TextSpan(
                            text: error.errorText,
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const TextSpan(text: '  →  '),
                          TextSpan(
                            text: error.correction,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Explanation
                    Text(
                      error.explanation,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onTertiaryContainer
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
