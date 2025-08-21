import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  /// Guardar sesión por rol
  static Future<void> saveSession(String role, String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_$role', token);
    await prefs.setString('username_$role', username);
  }

  /// Obtener token por rol
  static Future<String?> getToken(String role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token_$role');
  }

  /// Obtener username por rol
  static Future<String?> getUsername(String role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username_$role');
  }

  /// Cerrar sesión por rol
  static Future<void> clearSession(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_$role');
    await prefs.remove('username_$role');
  }

  /// Cerrar todas las sesiones (opcional)
  static Future<void> clearAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = ['admin', 'doctor', 'user'];
    for (final role in roles) {
      await prefs.remove('token_$role');
      await prefs.remove('username_$role');
    }
  }

  /// Verificar si hay sesión activa para un rol
  static Future<bool> isLoggedIn(String role) async {
    final token = await getToken(role);
    return token != null && token.isNotEmpty;
  }
}
