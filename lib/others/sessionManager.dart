import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {

  // Variables para almacenar los usernames localmente
  static String? adminUsername;
  static String? doctorUsername;
  static String? userUsername;

  /// Guardar sesión por rol
  static Future<void> saveSession(String role, String token, String username) async {
    final prefs = await SharedPreferences.getInstance();

    // Guardar en SharedPreferences
    await prefs.setString('token_$role', token);
    await prefs.setString('username_$role', username);

    // Guardar en las variables locales según el rol
    switch (role) {
      case 'admin':
        adminUsername = username;
        break;
      case 'doctor':
        doctorUsername = username;
        break;
      case 'user':
        userUsername = username;
        break;
    }
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

    // Limpiar la variable local correspondiente
    switch (role) {
      case 'admin':
        adminUsername = null;
        break;
      case 'doctor':
        doctorUsername = null;
        break;
      case 'user':
        userUsername = null;
        break;
    }
  }

  /// Cerrar todas las sesiones
  static Future<void> clearAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = ['admin', 'doctor', 'user'];
    for (final role in roles) {
      await prefs.remove('token_$role');
      await prefs.remove('username_$role');
    }

    // Limpiar todas las variables locales
    adminUsername = null;
    doctorUsername = null;
    userUsername = null;
  }

  /// Verificar si hay sesión activa para un rol
  static Future<bool> isLoggedIn(String role) async {
    final token = await getToken(role);
    return token != null && token.isNotEmpty;
  }
}
