import 'package:flutter/material.dart';

import '../../core/theme/theme_controller.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/scenarios/data/scenario_data.dart';

enum _ThemeModeOption { system, light, dark }

/// App shell that hosts a single conversation interface.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _scenario = ScenarioData.all.first;

  void _openThemeSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: AnimatedBuilder(
              animation: themeController,
              builder: (context, _) {
                final selectedMode = switch (themeController.themeMode) {
                  ThemeMode.light => _ThemeModeOption.light,
                  ThemeMode.dark => _ThemeModeOption.dark,
                  _ => _ThemeModeOption.system,
                };

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Theme', style: textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Text('Mode', style: textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SegmentedButton<_ThemeModeOption>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment<_ThemeModeOption>(
                          value: _ThemeModeOption.system,
                          icon: Icon(Icons.brightness_auto_rounded),
                          label: Text('System'),
                        ),
                        ButtonSegment<_ThemeModeOption>(
                          value: _ThemeModeOption.light,
                          icon: Icon(Icons.light_mode_rounded),
                          label: Text('Light'),
                        ),
                        ButtonSegment<_ThemeModeOption>(
                          value: _ThemeModeOption.dark,
                          icon: Icon(Icons.dark_mode_rounded),
                          label: Text('Dark'),
                        ),
                      ],
                      selected: {selectedMode},
                      onSelectionChanged: (selection) {
                        final mode = selection.first;
                        switch (mode) {
                          case _ThemeModeOption.system:
                            themeController.setThemeMode(ThemeMode.system);
                          case _ThemeModeOption.light:
                            themeController.setThemeMode(ThemeMode.light);
                          case _ThemeModeOption.dark:
                            themeController.setThemeMode(ThemeMode.dark);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('Suggested Palettes', style: textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _PresetChip(
                          label: 'Dynamic',
                          selected:
                              themeController.preset == ThemePreset.dynamic,
                          onTap: () =>
                              themeController.setPreset(ThemePreset.dynamic),
                        ),
                        _PresetChip(
                          label: 'Ocean',
                          selected: themeController.preset == ThemePreset.ocean,
                          onTap: () =>
                              themeController.setPreset(ThemePreset.ocean),
                        ),
                        _PresetChip(
                          label: 'Sunset',
                          selected:
                              themeController.preset == ThemePreset.sunset,
                          onTap: () =>
                              themeController.setPreset(ThemePreset.sunset),
                        ),
                        _PresetChip(
                          label: 'Forest',
                          selected:
                              themeController.preset == ThemePreset.forest,
                          onTap: () =>
                              themeController.setPreset(ThemePreset.forest),
                        ),
                        _PresetChip(
                          label: 'Graphite',
                          selected:
                              themeController.preset == ThemePreset.graphite,
                          onTap: () =>
                              themeController.setPreset(ThemePreset.graphite),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Dynamic follows your system palette. Suggestions use curated seeds.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreen(
      scenario: _scenario,
      showBackButton: false,
      appBarActions: [
        IconButton(
          onPressed: _openThemeSheet,
          icon: const Icon(Icons.palette_outlined),
          tooltip: 'Theme',
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
