import 'package:logger/logger.dart';

import 'gosignal_printer.dart';

final class Log {
  static final Logger _logger = Logger(
    printer: GoSignalPrinter(
      threshold: .debug,
      lineColored: true,
    ),
  );

  static void t(Object message, {String? tag}) => _logger.trace(tag, message);

  static void d(Object message, {String? tag}) => _logger.debug(tag, message);

  static void i(Object message, {String? tag}) => _logger.info(tag, message);

  static void w(Object message, {String? tag}) => _logger.warning(tag, message);

  static void e(
      Object message, {
        String? tag,
        Object? error,
        StackTrace? stackTrace,
      }) {
    _logger.error(
      tag,
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void f(Object message, {String? tag}) => _logger.fatal(tag, message);
}
