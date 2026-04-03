import 'package:flutter/material.dart';

/// Trial output generated with the flutter-md3-ui-engineer skill.
///
/// This screen intentionally demonstrates:
/// - CustomScrollView + slivers for scrollable page architecture
/// - Material 3 action hierarchy with FilledButton variants
/// - Theme-driven color and typography usage only
/// - NavigationBar for primary mobile destination switching
class HomeMd3TrialScreen extends StatefulWidget {
  const HomeMd3TrialScreen({super.key});

  @override
  State<HomeMd3TrialScreen> createState() => _HomeMd3TrialScreenState();
}

class _HomeMd3TrialScreenState extends State<HomeMd3TrialScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum_rounded),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart_rounded),
            label: 'Progress',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            backgroundColor: colorScheme.surface,
            title: Text('OpenSpeak', style: textTheme.headlineSmall),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            sliver: SliverToBoxAdapter(
              child: _HeroPanel(
                title: 'Speak every day, sound more natural',
                subtitle:
                    'Build momentum with short, focused conversations that adapt to your goals.',
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: _ActionRow(
                onPrimaryPressed: () {},
                onSecondaryPressed: () {},
                onTertiaryPressed: () {},
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            sliver: SliverToBoxAdapter(
              child: Text('Recommended Sessions', style: textTheme.titleLarge),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            sliver: SliverList.separated(
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _SessionCard(
                  title: 'Scenario ${index + 1}',
                  subtitle: 'Daily conversation · 8 min',
                  progressLabel: '${(index + 1) * 20}% complete',
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    required this.onTertiaryPressed,
  });

  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;
  final VoidCallback onTertiaryPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton(
          onPressed: onPrimaryPressed,
          child: const Text('Start Daily Session'),
        ),
        FilledButton.tonal(
          onPressed: onSecondaryPressed,
          child: const Text('Preview Plan'),
        ),
        OutlinedButton(
          onPressed: onTertiaryPressed,
          child: const Text('Customize'),
        ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.title,
    required this.subtitle,
    required this.progressLabel,
  });

  final String title;
  final String subtitle;
  final String progressLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.mic_none_rounded,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  progressLabel,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
