import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized environment configuration.
/// Reads values from the `.env` file loaded at app startup.
class EnvConfig {
  EnvConfig._();

  // --- Azure OpenAI ---
  static String get azureOpenAIEndpoint =>
      dotenv.env['AZURE_OPENAI_ENDPOINT'] ?? '';

  static String get azureOpenAIDeploymentId =>
      dotenv.env['AZURE_OPENAI_DEPLOYMENT_ID'] ?? 'gpt-4o';

  static String get azureOpenAIApiKey =>
      dotenv.env['AZURE_OPENAI_API_KEY'] ?? '';

  static String get azureOpenAIApiVersion =>
      dotenv.env['AZURE_OPENAI_API_VERSION'] ?? '2024-12-01-preview';

  static String get azureOpenAIChatUrl =>
      '$azureOpenAIEndpoint/openai/deployments/$azureOpenAIDeploymentId'
      '/chat/completions?api-version=$azureOpenAIApiVersion';

  // --- Azure Speech Services ---
  static String get azureSpeechKey => dotenv.env['AZURE_SPEECH_KEY'] ?? '';

  static String get azureSpeechRegion =>
      dotenv.env['AZURE_SPEECH_REGION'] ?? 'eastus';

  // --- Whisper STT (OpenAI-compatible) ---
  static String get whisperApiKey =>
      dotenv.env['WHISPER_API_KEY'] ?? cloudflareAIToken;

  static String get whisperBaseUrl =>
      dotenv.env['WHISPER_BASE_URL'] ?? cloudflareOpenAIBaseUrl;

  static String get whisperModel =>
      dotenv.env['WHISPER_MODEL'] ?? '@cf/openai/whisper-large-v3-turbo';

  // --- Google Cloud TTS ---
  static String get googleCloudTTSApiKey =>
      dotenv.env['GOOGLE_CLOUD_TTS_API_KEY'] ?? '';

  // --- Cloudflare Workers AI ---
  static String get cloudflareAccountId =>
      dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ?? '';

  static String get cloudflareAIToken =>
      dotenv.env['CLOUDFLARE_AI_API_TOKEN'] ?? '';

  static String get cloudflareOpenAIBaseUrl {
    if (cloudflareAccountId.isEmpty) return 'https://api.openai.com/v1';
    return 'https://api.cloudflare.com/client/v4/accounts/$cloudflareAccountId/ai/v1';
  }

  static String get cloudflareAIBaseUrl =>
      'https://api.cloudflare.com/client/v4/accounts/$cloudflareAccountId/ai/run';

  // --- App Config ---
  static bool get useMockServices =>
      dotenv.env['USE_MOCK_SERVICES']?.toLowerCase() == 'true';
}
