import "dart:async";
import "dart:io";

import "package:dio/dio.dart";
import "package:path_provider/path_provider.dart";
import "package:record/record.dart";

import "../config/env_config.dart";
import "stt_service.dart";

/// Whisper cloud STT implementation.
///
/// Strategy:
///  1. Record microphone to a temp WAV file using [record].
///  2. While recording, emit periodic partial STTResult as activity feedback.
///  3. On stopListening(), upload WAV to an OpenAI-compatible Whisper endpoint.
class WhisperSTTService implements STTService {
  final _recorder = AudioRecorder();
  late final Dio _dio;

  bool _isListening = false;
  StreamController<STTResult>? _controller;
  Timer? _partialTimer;
  String? _tempFilePath;
  String _language = "en-US";

  WhisperSTTService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.whisperBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          "Authorization": "Bearer ${EnvConfig.whisperApiKey}",
          "Accept": "application/json",
        },
      ),
    );
  }

  @override
  bool get isListening => _isListening;

  @override
  Stream<STTResult> startListening({String language = "en-US"}) {
    _controller = StreamController<STTResult>.broadcast();
    _isListening = true;
    _language = language;
    _startRecording();
    return _controller!.stream;
  }

  Future<void> _startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        _controller?.addError("Microphone permission denied");
        return;
      }

      if (EnvConfig.whisperApiKey.isEmpty) {
        _controller?.addError("WHISPER_API_KEY is not configured");
        return;
      }

      final dir = await getTemporaryDirectory();
      _tempFilePath =
          "${dir.path}/openspeak_whisper_${DateTime.now().millisecondsSinceEpoch}.wav";

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: _tempFilePath!,
      );

      int dots = 0;
      _partialTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
        if (!_isListening) return;
        dots++;
        final indicator = "Listening${"." * (dots % 4)}";
        _controller?.add(
          STTResult(text: indicator, isFinal: false, confidence: 0.0),
        );
      });
    } catch (e) {
      _controller?.addError(e);
    }
  }

  @override
  Future<void> stopListening() async {
    if (!_isListening) return;
    _isListening = false;
    _partialTimer?.cancel();
    _partialTimer = null;

    try {
      await _recorder.stop();

      final file = _tempFilePath != null ? File(_tempFilePath!) : null;
      if (file != null && await file.exists()) {
        final text = await _transcribeFile(file, _language);
        if (text != null && text.isNotEmpty) {
          _controller?.add(
            STTResult(text: text, isFinal: true, confidence: 0.95),
          );
        }
        await file.delete();
      }
    } catch (e) {
      _controller?.addError(e);
    } finally {
      await _controller?.close();
      _controller = null;
      _tempFilePath = null;
    }
  }

  Future<String?> _transcribeFile(File file, String language) async {
    try {
      final locale = language.split("-").first.toLowerCase();
      final form = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: "audio.wav"),
        "model": EnvConfig.whisperModel,
        "language": locale,
        "response_format": "json",
      });

      final response = await _dio.post<Map<String, dynamic>>(
        "/audio/transcriptions",
        data: form,
        options: Options(contentType: "multipart/form-data"),
      );

      return response.data?["text"] as String?;
    } on DioException catch (_) {
      return null;
    }
  }
}
