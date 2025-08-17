import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyRole = "role";
  static const String _keyToken = "token";
  static const String _keyUsername = "username";


  /// Guardar sesión
  static Future<void> saveSession(String role, String token, String username,
) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUsername, username);
  }

  /// Obtener rol
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  /// Obtener token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Obtener username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
  /// Cerrar sesión
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
