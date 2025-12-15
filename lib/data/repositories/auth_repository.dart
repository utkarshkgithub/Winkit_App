import '../models/auth_request.dart';
import '../models/user_model.dart';
import '../sources/auth_data_source.dart';
import '../../common/storage/token_storage.dart';

class AuthRepository {
  final AuthDataSource dataSource;
  final TokenStorage tokenStorage;

  AuthRepository({required this.dataSource, required this.tokenStorage});

  /// Login user and save token
  Future<UserModel> login(String username, String password) async {
    try {
      final request = LoginRequest(username: username, password: password);

      final response = await dataSource.login(request);

      // Save access token (prefer accessToken from JWT response)
      final tokenToSave = response.accessToken ?? response.token;

      if (tokenToSave != null) {
        await tokenStorage.saveToken(tokenToSave);

        if (response.user != null) {
          await tokenStorage.saveUserId(response.user!.id);
          return response.user!;
        }

        // If user not in response, fetch it
        return await getCurrentUser();
      }

      throw Exception(response.message ?? 'Login failed');
    } catch (e) {
      rethrow;
    }
  }

  /// Register new user and save token
  Future<UserModel> signup(SignupRequest request) async {
    try {
      final response = await dataSource.signup(request);

      // Save access token (prefer accessToken from JWT response)
      final tokenToSave = response.accessToken ?? response.token;

      if (tokenToSave != null) {
        await tokenStorage.saveToken(tokenToSave);

        if (response.user != null) {
          await tokenStorage.saveUserId(response.user!.id);
          return response.user!;
        }

        // If user not in response, fetch it
        return await getCurrentUser();
      }

      throw Exception(response.message ?? 'Signup failed');
    } catch (e) {
      rethrow;
    }
  }

  /// Get current logged-in user
  Future<UserModel> getCurrentUser() async {
    try {
      final token = tokenStorage.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      return await dataSource.getCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await tokenStorage.clear();
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return tokenStorage.hasToken();
  }

  /// Get stored token
  String? getToken() {
    return tokenStorage.getToken();
  }
}
