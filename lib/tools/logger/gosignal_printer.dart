import 'package:logger/logger.dart';

final class WeatherPrinter extends LogPrinter {
  Level threshold;
  bool lineColored;

  WeatherPrinter({
    this.threshold = Level.info,
    this.lineColored = false,
  });

  static const _levelNames = <Level, String>{
    Level.trace: 'TRACE',
    Level.debug: 'DEBUG',
    Level.info: 'INFO ',
    Level.warning: 'WARN ',
    Level.error: 'ERROR',
    Level.fatal: 'FATAL',
  };

  static const _levelColors = <Level, AnsiColor>{
    Level.trace: AnsiColor.fg(14),
    Level.debug: AnsiColor.fg(10),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(11),
    Level.error: AnsiColor.fg(9),
    Level.fatal: AnsiColor.fg(13),
  };

  @override
  List<String> log(LogEvent event) {
    if (event.level < threshold) return [];

    final color = _levelColors[event.level] ?? AnsiColor.none();
    final level = _levelNames[event.level] ?? event.level.name.toUpperCase();

    final now = event.time;
    final absoluteTime = _formatTime(now);

    final tag = event.message is _LogMessage ? (event.message as _LogMessage).tag : null;

    final message = event.message is _LogMessage ? (event.message as _LogMessage).message : event.message;

    late List<String> lines;
    if (lineColored) {
      final tagPart = tag == null ? '' : '[${tag.padRight(5)}] ';
      lines = <String>[
        color(
          '$absoluteTime '
          '${level.padRight(5)}  '
          '$tagPart$message',
        ),
      ];
    } else {
      final rawLevel = level.padRight(5);
      final rawTag = tag == null ? '' : '[$tag]'.padRight(5);
      lines = <String>[
        '$absoluteTime '
            '${color(rawLevel)}  '
            '${color(rawTag)} '
            '$message',
      ];
    }

    if (event.error != null) {
      lines.add(color('    └─ ${event.error}'));
    }

    if (event.stackTrace != null) {
      for (final line in event.stackTrace.toString().trimRight().split('\n')) {
        lines.add(color('       $line'));
      }
    }

    return lines;
  }

  String _formatTime(DateTime value) {
    String two(int value) => value.toString().padLeft(2, '0');
    String three(int value) => value.toString().padLeft(3, '0');

    return '${two(value.hour)}:'
        '${two(value.minute)}:'
        '${two(value.second)}.'
        '${three(value.millisecond)}';
  }
}

final class _LogMessage {
  const _LogMessage(
    this.message, {
    this.tag,
  });

  final String? tag;
  final Object message;

  @override
  String toString() => message.toString();
}

extension TaggedLogger on Logger {
  void trace(String? tag, Object message) {
    t(_LogMessage(message, tag: tag));
  }

  void debug(String? tag, Object message) {
    d(_LogMessage(message, tag: tag));
  }

  void info(String? tag, Object message) {
    i(_LogMessage(message, tag: tag));
  }

  void warning(String? tag, Object message) {
    w(_LogMessage(message, tag: tag));
  }

  void fatal(String? tag, Object message) {
    f(_LogMessage(message, tag: tag));
  }

  void error(
    String? tag,
    Object message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    e(
      _LogMessage(message, tag: tag),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
