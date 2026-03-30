import "dart:async";
import "dart:convert";

import "package:dio/dio.dart";

import "../config/env_config.dart";
import "../models/chat_message.dart";
import "chat_ai_service.dart";

/// Azure OpenAI / AI Foundry implementation using streaming SSE.
class AzureChatAIService implements ChatAIService {
  late final Dio _dio;
  late final String _url;
  late final String _model;

  AzureChatAIService() {
    final endpoint = EnvConfig.azureOpenAIEndpoint;
    _model = EnvConfig.azureOpenAIDeploymentId;

    // Ensure endpoint ends at /v1 (strip trailing /responses or similar)
    final base = endpoint
        .replaceAll(RegExp(r"/responses$"), "")
        .replaceAll(RegExp(r"/chat/completions$"), "");
    final v1base = base.endsWith("/v1") ? base : "$base/v1";
    _url = "$v1base/chat/completions";

    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 120),
      headers: {
        "api-key": EnvConfig.azureOpenAIApiKey,
        "Content-Type": "application/json",
      },
      responseType: ResponseType.plain,
    ));
  }

  List<Map<String, String>> _buildMessages(
    List<ChatMessage> history,
    String userMessage,
    String systemPrompt,
  ) {
    return [
      {"role": "system", "content": systemPrompt},
      ...history.map((m) => {
        "role": m.role == MessageRole.user ? "user" : "assistant",
        "content": m.content,
      }),
      {"role": "user", "content": userMessage},
    ];
  }

  @override
  Future<String> sendMessage({
    required List<ChatMessage> history,
    required String userMessage,
    required String systemPrompt,
  }) async {
    final buffer = StringBuffer();
    await for (final token in sendMessageStream(
      history: history,
      userMessage: userMessage,
      systemPrompt: systemPrompt,
    )) {
      buffer.write(token);
    }
    return buffer.toString();
  }

  @override
  Stream<String> sendMessageStream({
    required List<ChatMessage> history,
    required String userMessage,
    required String systemPrompt,
  }) async* {
    final response = await _dio.post<String>(
      _url,
      data: jsonEncode({
        "model": _model,
        "messages": _buildMessages(history, userMessage, systemPrompt),
        "max_completion_tokens": 512,
        "stream": true,
      }),
      options: Options(responseType: ResponseType.stream),
    );

    // Parse SSE stream
    final stream = response.data as ResponseBody;
    final buffer = StringBuffer();

    await for (final chunk in stream.stream) {
      buffer.write(utf8.decode(chunk));
      final lines = buffer.toString().split("\n");
      buffer.clear();
      if (!buffer.toString().endsWith("\n")) {
        // Keep incomplete last line in buffer
        buffer.write(lines.removeLast());
      }
      for (final line in lines) {
        if (!line.startsWith("data: ")) continue;
        final data = line.substring(6).trim();
        if (data == "[DONE]") return;
        try {
          final json = jsonDecode(data);
          final delta = json["choices"]?[0]?["delta"]?["content"];
          if (delta != null && delta is String && delta.isNotEmpty) {
            yield delta;
          }
        } catch (_) {}
      }
    }
  }
}