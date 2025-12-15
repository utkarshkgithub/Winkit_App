import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../common/storage/token_storage.dart';
import '../../common/utils/network_logger_interceptor.dart';
import '../../app/config/api_config.dart';
import '../errors/exceptions.dart';

class DioClient {
  late final Dio _dio;
  final TokenStorage tokenStorage;

  DioClient({required this.tokenStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add network logger interceptor (only in debug mode)
    if (kDebugMode) {
      _dio.interceptors.add(NetworkLoggerInterceptor());
    }

    // Add auth and error handling interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = tokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors globally
          if (error.response?.statusCode == 401) {
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: UnauthorizedException(),
              ),
            );
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return NetworkException(message: 'Connection timeout. Please try again.');
    }

    if (error.type == DioExceptionType.connectionError) {
      return NetworkException(
        message: 'No internet connection. Please check your network.',
      );
    }

    if (error.error is UnauthorizedException) {
      return error.error as UnauthorizedException;
    }

    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    String message = 'An error occurred';

    if (responseData is Map<String, dynamic>) {
      // Try to extract error message from response
      if (responseData.containsKey('detail')) {
        message = responseData['detail'].toString();
      } else if (responseData.containsKey('message')) {
        message = responseData['message'].toString();
      } else {
        // Handle field-specific errors
        message = responseData.values.first.toString();
      }
    } else if (responseData is String) {
      message = responseData;
    }

    return ServerException(message: message, statusCode: statusCode);
  }
}
