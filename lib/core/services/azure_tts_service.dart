import "dart:typed_data";

import "package:dio/dio.dart";

import "../config/env_config.dart";
import "tts_service.dart";

/// Azure Speech Services TTS implementation.
class AzureTTSService implements TTSService {
  late final Dio _dio;
  late final String _url;
  String _voiceName = "en-US-JennyNeural";

  AzureTTSService() {
    final region = EnvConfig.azureSpeechRegion;
    _url = "https://$region.tts.speech.microsoft.com/cognitiveservices/v1";
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Ocp-Apim-Subscription-Key": EnvConfig.azureSpeechKey,
        "Content-Type": "application/ssml+xml",
        "X-Microsoft-OutputFormat": "audio-16khz-32kbitrate-mono-mp3",
      },
      responseType: ResponseType.bytes,
    ));
  }

  String _buildSsml(String text, String voice) {
    // Escape XML special chars
    final escaped = text
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;");
    final lang = voice.substring(0, 5); // e.g. en-US
    return "<speak version='1.0' xml:lang='$lang'>"
        "<voice name='$voice'>$escaped</voice>"
        "</speak>";
  }

  @override
  Future<Uint8List> synthesize(String text, {String? voiceName}) async {
    final voice = voiceName ?? _voiceName;
    final response = await _dio.post<List<int>>(
      _url,
      data: _buildSsml(text, voice),
    );
    return Uint8List.fromList(response.data ?? []);
  }

  @override
  Future<List<VoiceOption>> getAvailableVoices() async {
    return const [
      VoiceOption(id: "en-US-JennyNeural", name: "Jenny", language: "en-US", gender: "Female", provider: "azure"),
      VoiceOption(id: "en-US-GuyNeural", name: "Guy", language: "en-US", gender: "Male", provider: "azure"),
      VoiceOption(id: "en-US-AriaNeural", name: "Aria", language: "en-US", gender: "Female", provider: "azure"),
      VoiceOption(id: "en-US-DavisNeural", name: "Davis", language: "en-US", gender: "Male", provider: "azure"),
      VoiceOption(id: "en-GB-SoniaNeural", name: "Sonia", language: "en-GB", gender: "Female", provider: "azure"),
      VoiceOption(id: "en-AU-NatashaNeural", name: "Natasha", language: "en-AU", gender: "Female", provider: "azure"),
    ];
  }
}