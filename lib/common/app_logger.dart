import 'package:logger/logger.dart';

class AppLogger {
  const AppLogger._();

  static final _logger = Logger();

  static void d(String message) {
    _logger.d(message);
  }

  static Future<void> e(String message, {Error? e, StackTrace? s}) async {
    _logger.e(message, error: e, stackTrace: s);
  }
}
