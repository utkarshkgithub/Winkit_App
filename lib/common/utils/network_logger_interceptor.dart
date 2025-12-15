import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/logger.dart';

class NetworkLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();

    AppLogger.network(
      'REQUEST ${options.method} ${options.uri}',
    );

    if (options.headers.isNotEmpty) {
      AppLogger.network('Headers:');
      options.headers.forEach((key, value) {
        AppLogger.network('  $key: ${_mask(key, value)}');
      });
    }

    if (options.queryParameters.isNotEmpty) {
      AppLogger.network('Query: ${options.queryParameters}');
    }

    if (options.data != null) {
      AppLogger.network('Body:\n${_pretty(options.data)}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;
    final duration = startTime == null
        ? null
        : DateTime.now().difference(startTime).inMilliseconds;

    AppLogger.network(
      'RESPONSE ${response.statusCode} ${response.requestOptions.uri}'
      '${duration != null ? ' (${duration}ms)' : ''}',
    );

    if (response.data != null) {
      AppLogger.network('Body:\n${_pretty(response.data)}');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['startTime'] as DateTime?;
    final duration = startTime == null
        ? null
        : DateTime.now().difference(startTime).inMilliseconds;

    AppLogger.network(
      'ERROR ${err.requestOptions.method} ${err.requestOptions.uri}'
      '${duration != null ? ' (${duration}ms)' : ''}',
    );

    AppLogger.network('Type: ${err.type}');

    if (err.response != null) {
      AppLogger.network(
        'Status: ${err.response?.statusCode}\n'
        'Body:\n${_pretty(err.response?.data)}',
      );
    } else {
      AppLogger.network('Message: ${err.message}');
    }

    handler.next(err);
  }

  String _pretty(dynamic data) {
    try {
      if (data is String) {
        return const JsonEncoder.withIndent('  ')
            .convert(jsonDecode(data));
      }
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _mask(String key, dynamic value) {
    const sensitive = [
      'authorization',
      'token',
      'password',
      'secret',
      'api-key',
      'apikey',
    ];

    return sensitive.any((k) => key.toLowerCase().contains(k))
        ? '***'
        : value.toString();
  }
}
