/// Represents a learning scenario that the user can practice.
class Scenario {
  final String id;
  final String title;
  final String description;
  final String iconCodePoint; // Material icon code point
  final ScenarioDifficulty difficulty;
  final ScenarioCategory category;
  final String systemPrompt;

  const Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.difficulty,
    required this.category,
    required this.systemPrompt,
  });
}

enum ScenarioDifficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  final String label;
  const ScenarioDifficulty(this.label);
}

enum ScenarioCategory {
  dailyLife('Daily Life', '0xe88a'), // home icon
  business('Business', '0xef3d'),   // business_center icon
  travel('Travel', '0xe539'),       // flight icon
  academic('Academic', '0xe80c');    // school icon

  final String label;
  final String iconCode;
  const ScenarioCategory(this.label, this.iconCode);
}
