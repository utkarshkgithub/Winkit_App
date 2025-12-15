import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/logger.dart';

/// Dio interceptor for logging all network requests and responses.
class NetworkLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final stopwatch = Stopwatch()..start();
    options.extra['stopwatch'] = stopwatch;

    AppLogger.network(
      '╔═══════════════════════════════════════════════════════════════',
    );
    AppLogger.network('║ 🚀 REQUEST → ${options.method} ${options.uri}');
    AppLogger.network(
      '╠═══════════════════════════════════════════════════════════════',
    );

    if (options.headers.isNotEmpty) {
      AppLogger.network('║ Headers:');
      options.headers.forEach((key, value) {
        // Mask sensitive headers
        final maskedValue = _maskSensitiveData(key, value);
        AppLogger.network('║   $key: $maskedValue');
      });
    }

    if (options.queryParameters.isNotEmpty) {
      AppLogger.network('║ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        AppLogger.network('║   $key: $value');
      });
    }

    if (options.data != null) {
      AppLogger.network('║ Body:');
      try {
        final prettyData = _formatJson(options.data);
        for (var line in prettyData.split('\n')) {
          AppLogger.network('║   $line');
        }
      } catch (e) {
        AppLogger.network('║   ${options.data}');
      }
    }

    AppLogger.network(
      '╚═══════════════════════════════════════════════════════════════',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final stopwatch = response.requestOptions.extra['stopwatch'] as Stopwatch?;
    stopwatch?.stop();
    final duration = stopwatch?.elapsedMilliseconds ?? 0;

    AppLogger.network(
      '╔═══════════════════════════════════════════════════════════════',
    );
    AppLogger.network(
      '║ ✅ RESPONSE ← ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    AppLogger.network('║ Status Code: ${response.statusCode}');
    AppLogger.network('║ Duration: ${duration}ms');
    AppLogger.network(
      '╠═══════════════════════════════════════════════════════════════',
    );

    if (response.headers.map.isNotEmpty) {
      AppLogger.network('║ Headers:');
      response.headers.map.forEach((key, value) {
        AppLogger.network('║   $key: ${value.join(", ")}');
      });
    }

    if (response.data != null) {
      AppLogger.network('║ Response Body:');
      try {
        final prettyData = _formatJson(response.data);
        final lines = prettyData.split('\n');
        // Limit response body to first 50 lines to avoid console spam
        final displayLines = lines.take(50);
        for (var line in displayLines) {
          AppLogger.network('║   $line');
        }
        if (lines.length > 50) {
          AppLogger.network('║   ... (${lines.length - 50} more lines)');
        }
      } catch (e) {
        AppLogger.network('║   ${response.data}');
      }
    }

    AppLogger.network(
      '╚═══════════════════════════════════════════════════════════════',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final stopwatch = err.requestOptions.extra['stopwatch'] as Stopwatch?;
    stopwatch?.stop();
    final duration = stopwatch?.elapsedMilliseconds ?? 0;

    AppLogger.network(
      '╔═══════════════════════════════════════════════════════════════',
    );
    AppLogger.network(
      '║ ❌ ERROR ← ${err.requestOptions.method} ${err.requestOptions.uri}',
    );
    AppLogger.network('║ Error Type: ${err.type}');
    AppLogger.network('║ Duration: ${duration}ms');
    AppLogger.network(
      '╠═══════════════════════════════════════════════════════════════',
    );

    if (err.response != null) {
      AppLogger.network('║ Status Code: ${err.response?.statusCode}');
      AppLogger.network('║ Response:');
      try {
        final prettyData = _formatJson(err.response?.data);
        for (var line in prettyData.split('\n')) {
          AppLogger.network('║   $line');
        }
      } catch (e) {
        AppLogger.network('║   ${err.response?.data}');
      }
    } else {
      AppLogger.network('║ Message: ${err.message}');
    }

    AppLogger.network(
      '╚═══════════════════════════════════════════════════════════════',
    );

    super.onError(err, handler);
  }

  /// Format JSON data for pretty printing
  String _formatJson(dynamic data) {
    if (data == null) return 'null';

    try {
      // If data is already a string, try to parse it first
      if (data is String) {
        final decoded = jsonDecode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      }
      // Otherwise, encode directly
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  /// Mask sensitive data in headers (like tokens, passwords)
  String _maskSensitiveData(String key, dynamic value) {
    final sensitiveKeys = [
      'authorization',
      'token',
      'password',
      'secret',
      'api-key',
      'apikey',
    ];

    if (sensitiveKeys.any((k) => key.toLowerCase().contains(k))) {
      return '***MASKED***';
    }

    return value.toString();
  }
}
