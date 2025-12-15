import 'package:equatable/equatable.dart';
import 'user_model.dart';

class AuthResponse extends Equatable {
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;
  final String? message;

  const AuthResponse({
    this.token,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    String? accessToken;
    String? refreshToken;

    // Handle different response formats
    // Format 1: { "tokens": { "access": "...", "refresh": "..." } }
    if (json['tokens'] != null && json['tokens'] is Map) {
      accessToken = json['tokens']['access'] as String?;
      refreshToken = json['tokens']['refresh'] as String?;
    }
    // Format 2: { "access": "...", "refresh": "..." }
    else if (json['access'] != null) {
      accessToken = json['access'] as String?;
      refreshToken = json['refresh'] as String?;
    }
    // Format 3: { "token": "..." }

    return AuthResponse(
      token: json['token'] as String?,
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [token, accessToken, refreshToken, user, message];
}
