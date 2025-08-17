// token_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  String? token;

  // Singleton pattern opcional (si lo quieres usar en varios lugares sin reinstancia)
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  Future<void> ensureTokenInitialized() async {
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('jwt_token');
      if (token == null) {
        throw Exception("Token no encontrado, por favor loguearse");
      }
    }
    else{
      print("Token encontrado");
    }
  }

  Future<void> setToken(String newToken) async {
    token = newToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', newToken);
  }

  Future<String> getToken() async {
    await ensureTokenInitialized();
    return token!;
  }

  Future<void> logout() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  bool get isTokenInMemory => token != null;
}
