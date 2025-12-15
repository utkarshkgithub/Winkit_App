import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Load backend URL from environment variables
  static String get baseUrl =>
      dotenv.env['BACKEND_API'] ?? 'http://localhost:8000';
  static const String apiPrefix = '/api';

  // Authentication endpoints
  static const String signupEndpoint = '$apiPrefix/auth/signup';
  static const String loginEndpoint = '$apiPrefix/auth/login';
  static const String meEndpoint = '$apiPrefix/auth/me';

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> headersWithAuth(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization':
        'Token $token', // Adjust based on your Django auth (Token/Bearer)
  };
}
