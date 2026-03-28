import 'package:flutter/material.dart';

/// Settings screen for app configuration.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                'Settings',
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voice section
                  _SectionTitle(
                    title: 'Voice & Speech',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.record_voice_over_rounded,
                    title: 'TTS Engine',
                    subtitle: 'Azure Speech (default)',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.person_rounded,
                    title: 'Voice Character',
                    subtitle: 'Jenny (Female, en-US)',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.speed_rounded,
                    title: 'Speaking Speed',
                    subtitle: 'Normal',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: () {},
                  ),

                  const SizedBox(height: 28),

                  // Appearance
                  _SectionTitle(
                    title: 'Appearance',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.dark_mode_rounded,
                    title: 'Theme',
                    subtitle: 'System default',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: () {},
                  ),

                  const SizedBox(height: 28),

                  // Learning
                  _SectionTitle(
                    title: 'Learning',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.flag_rounded,
                    title: 'Daily Goal',
                    subtitle: '3 conversations per day',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.translate_rounded,
                    title: 'Native Language',
                    subtitle: '中文 (Chinese)',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: () {},
                  ),

                  const SizedBox(height: 28),

                  // About
                  _SectionTitle(
                    title: 'About',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Version',
                    subtitle: '1.0.0',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: () {},
                    showChevron: false,
                  ),
                  _SettingsTile(
                    icon: Icons.code_rounded,
                    title: 'API Configuration',
                    subtitle: 'Mock services active',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _SectionTitle({
    required this.title,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textTheme.titleSmall?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;
  final bool showChevron;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
