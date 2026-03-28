import 'dart:async';
import 'dart:typed_data';

/// Abstract interface for Text-to-Speech services.
abstract class TTSService {
  /// Converts text to speech audio bytes.
  Future<Uint8List> synthesize(String text, {String? voiceName});

  /// Returns available voice options.
  Future<List<VoiceOption>> getAvailableVoices();
}

/// Represents a TTS voice option.
class VoiceOption {
  final String id;
  final String name;
  final String language;
  final String gender;
  final String provider; // 'azure' or 'google'

  const VoiceOption({
    required this.id,
    required this.name,
    required this.language,
    required this.gender,
    required this.provider,
  });
}

/// Mock TTS that skips actual audio synthesis.
class MockTTSService implements TTSService {
  @override
  Future<Uint8List> synthesize(String text, {String? voiceName}) async {
    // In mock mode, we just simulate a delay and return empty bytes.
    // The UI will still show the playback controls but skip real audio.
    await Future.delayed(const Duration(milliseconds: 300));
    return Uint8List(0);
  }

  @override
  Future<List<VoiceOption>> getAvailableVoices() async {
    return const [
      VoiceOption(
        id: 'en-US-JennyNeural',
        name: 'Jenny',
        language: 'en-US',
        gender: 'Female',
        provider: 'azure',
      ),
      VoiceOption(
        id: 'en-US-GuyNeural',
        name: 'Guy',
        language: 'en-US',
        gender: 'Male',
        provider: 'azure',
      ),
      VoiceOption(
        id: 'en-GB-SoniaNeural',
        name: 'Sonia',
        language: 'en-GB',
        gender: 'Female',
        provider: 'azure',
      ),
      VoiceOption(
        id: 'en-US-Wavenet-D',
        name: 'Alex',
        language: 'en-US',
        gender: 'Male',
        provider: 'google',
      ),
      VoiceOption(
        id: 'en-US-Wavenet-F',
        name: 'Clara',
        language: 'en-US',
        gender: 'Female',
        provider: 'google',
      ),
    ];
  }
}
