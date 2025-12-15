import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../../core/network/dio_client.dart';

class AuthDataSource {
  final DioClient client;

  AuthDataSource(this.client);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await client.post('/auth/login', data: request.toJson());
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> signup(SignupRequest request) async {
    final response = await client.post('/auth/signup', data: request.toJson());
    return AuthResponse.fromJson(response.data);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await client.get('/auth/me');
    return UserModel.fromJson(response.data);
  }
}
