import "dart:convert";

import "package:dio/dio.dart";

import "../config/env_config.dart";
import "../models/chat_message.dart";
import "grammar_check_service.dart";

/// Cloudflare Workers AI grammar checking service.
class CloudflareGrammarService implements GrammarCheckService {
  late final Dio _dio;
  late final String _url;

  CloudflareGrammarService() {
    final accountId = EnvConfig.cloudflareAccountId;
    _url = "https://api.cloudflare.com/client/v4/accounts/$accountId"
        "/ai/run/@cf/meta/llama-3.1-8b-instruct";
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Authorization": "Bearer ${EnvConfig.cloudflareAIToken}",
        "Content-Type": "application/json",
      },
    ));
  }

  static const _systemPrompt = """You are a precise English grammar checker for language learners.
Analyze the user sentence and respond in JSON format ONLY with no extra text:
{"correct": true} if the sentence is grammatically correct,
OR
{"correct": false, "errors": [{"error": "the wrong part", "correction": "the correct version", "explanation": "brief rule explanation"}]}
Limit to max 2 errors. Be concise.""";

  @override
  Future<GrammarFeedback?> checkGrammar(String text) async {
    if (text.trim().length < 3) return null;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _url,
        data: jsonEncode({
          "messages": [
            {"role": "system", "content": _systemPrompt},
            {"role": "user", "content": text},
          ],
        }),
      );

      final raw = response.data?["result"]?["response"] as String?;
      if (raw == null) return null;

      // Extract JSON from response (model might wrap it in text)
      final jsonMatch = RegExp(r"\{.*\}", dotAll: true).firstMatch(raw);
      if (jsonMatch == null) return null;
      final parsed = jsonDecode(jsonMatch.group(0)!);

      if (parsed["correct"] == true) return null;

      final errors = (parsed["errors"] as List?)?.map((e) {
        return GrammarError(
          errorText: e["error"] ?? "",
          correction: e["correction"] ?? "",
          explanation: e["explanation"] ?? "",
        );
      }).toList();

      if (errors == null || errors.isEmpty) return null;

      return GrammarFeedback(
        originalText: text,
        correctedText: errors.map((e) => e.correction).join("; "),
        errors: errors,
      );
    } catch (_) {
      return null; // Grammar check failure is non-fatal
    }
  }
}

