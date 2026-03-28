import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class LoggerService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  void d(dynamic message) => _logger.d(message);
  void i(dynamic message) => _logger.i(message);
  void w(dynamic message) => _logger.w(message);
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) => _logger.e(message, time: DateTime.now(), error: error, stackTrace: stackTrace);
}
