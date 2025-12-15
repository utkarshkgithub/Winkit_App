import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  static Future<TokenStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return TokenStorage(prefs);
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
  }

  int? getUserId() {
    return _prefs.getInt(_userIdKey);
  }

  Future<void> clear() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
  }

  bool hasToken() {
    return _prefs.containsKey(_tokenKey);
  }
}
