import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralized app logger with different log levels and categories.
class AppLogger {
  static const String _name = 'WinkitApp';

  /// Log general information
  static void info(String message, [Object? data]) {
    _log('INFO', message, data);
  }

  /// Log errors with optional error object and stack trace
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log('ERROR', message, error);
    if (stackTrace != null && kDebugMode) {
      developer.log(stackTrace.toString(), name: _name, error: error);
    }
  }

  /// Log warnings
  static void warning(String message, [Object? data]) {
    _log('WARNING', message, data);
  }

  /// Log debug information (only in debug mode)
  static void debug(String message, [Object? data]) {
    if (kDebugMode) {
      _log('DEBUG', message, data);
    }
  }

  /// Log network-related activities
  static void network(String message, [Object? data]) {
    if (kDebugMode) {
      _log('NETWORK', message, data);
    }
  }

  /// Internal log method
  static void _log(String level, String message, [Object? data]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final buffer = StringBuffer();
      buffer.write('[$timestamp] [$level] $message');

      if (data != null) {
        buffer.write('\n');
        buffer.write(_formatData(data));
      }

      developer.log(buffer.toString(), name: _name, time: DateTime.now());

      // Also print to console for visibility
      debugPrint(buffer.toString());
    }
  }

  /// Format data for logging
  static String _formatData(Object data) {
    if (data is Map) {
      return data.entries.map((e) => '  ${e.key}: ${e.value}').join('\n');
    }
    return '  $data';
  }
}
