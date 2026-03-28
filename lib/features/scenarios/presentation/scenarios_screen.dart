import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/scenario.dart';
import '../../chat/domain/providers.dart';
import '../../chat/presentation/chat_screen.dart';
import 'widgets/scenario_card.dart';

/// Scenario selection screen with category tabs.
class ScenariosScreen extends ConsumerStatefulWidget {
  const ScenariosScreen({super.key});

  @override
  ConsumerState<ScenariosScreen> createState() => _ScenariosScreenState();
}

class _ScenariosScreenState extends ConsumerState<ScenariosScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _categories = ScenarioCategory.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: 140,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 60),
              title: Text(
                'Scenarios',
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              dividerColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
              labelStyle: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: _categories.map((c) => Tab(text: c.label)).toList(),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: _categories.map((category) {
            final scenarios = ref.watch(scenariosByCategoryProvider(category));
            return _ScenarioGrid(
              scenarios: scenarios,
              onScenarioTap: (scenario) => _openChat(context, scenario),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _openChat(BuildContext context, Scenario scenario) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(scenario: scenario),
      ),
    );
  }
}

class _ScenarioGrid extends StatelessWidget {
  final List<Scenario> scenarios;
  final ValueChanged<Scenario> onScenarioTap;

  const _ScenarioGrid({
    required this.scenarios,
    required this.onScenarioTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: scenarios.length,
      itemBuilder: (context, index) {
        return ScenarioCard(
          scenario: scenarios[index],
          onTap: () => onScenarioTap(scenarios[index]),
        );
      },
    );
  }
}
