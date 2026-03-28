import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/scenario.dart';
import '../../../core/services/chat_ai_service.dart';
import '../../../core/services/grammar_check_service.dart';
import '../../../core/services/stt_service.dart';
import '../../../core/services/tts_service.dart';
import '../data/chat_repository.dart';
import '../../scenarios/data/scenario_data.dart';

// --- Service Providers ---

final chatAIServiceProvider = Provider<ChatAIService>((ref) {
  return MockChatAIService();
});

final grammarCheckServiceProvider = Provider<GrammarCheckService>((ref) {
  return MockGrammarCheckService();
});

final ttsServiceProvider = Provider<TTSService>((ref) {
  return MockTTSService();
});

final sttServiceProvider = Provider<STTService>((ref) {
  return MockSTTService();
});

// --- Repository Provider ---

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    chatAI: ref.watch(chatAIServiceProvider),
    grammarCheck: ref.watch(grammarCheckServiceProvider),
    tts: ref.watch(ttsServiceProvider),
    stt: ref.watch(sttServiceProvider),
  );
});

// --- Scenario Providers ---

final allScenariosProvider = Provider<List<Scenario>>((ref) {
  return ScenarioData.all;
});

final scenariosByCategoryProvider =
    Provider.family<List<Scenario>, ScenarioCategory>((ref, category) {
  return ScenarioData.byCategory(category);
});

final selectedScenarioProvider =
    Provider.family<Scenario?, String>((ref, scenarioId) {
  final scenarios = ref.watch(allScenariosProvider);
  try {
    return scenarios.firstWhere((s) => s.id == scenarioId);
  } catch (_) {
    return null;
  }
});
