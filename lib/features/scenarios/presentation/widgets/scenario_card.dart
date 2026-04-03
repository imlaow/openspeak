import 'package:flutter/material.dart';

import '../../../../core/models/scenario.dart';

/// A card representing a learning scenario.
class ScenarioCard extends StatelessWidget {
  final Scenario scenario;
  final VoidCallback onTap;

  const ScenarioCard({super.key, required this.scenario, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  scenario.iconData,
                  size: 24,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                scenario.title,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Description
              Text(
                scenario.description,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Difficulty badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _difficultyColor(scenario.difficulty, colorScheme),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  scenario.difficulty.label,
                  style: textTheme.labelSmall?.copyWith(
                    color: _difficultyTextColor(
                      scenario.difficulty,
                      colorScheme,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _difficultyColor(
    ScenarioDifficulty difficulty,
    ColorScheme colorScheme,
  ) {
    switch (difficulty) {
      case ScenarioDifficulty.beginner:
        return colorScheme.tertiaryContainer;
      case ScenarioDifficulty.intermediate:
        return colorScheme.secondaryContainer;
      case ScenarioDifficulty.advanced:
        return colorScheme.errorContainer;
    }
  }

  Color _difficultyTextColor(
    ScenarioDifficulty difficulty,
    ColorScheme colorScheme,
  ) {
    switch (difficulty) {
      case ScenarioDifficulty.beginner:
        return colorScheme.onTertiaryContainer;
      case ScenarioDifficulty.intermediate:
        return colorScheme.onSecondaryContainer;
      case ScenarioDifficulty.advanced:
        return colorScheme.onErrorContainer;
    }
  }
}
