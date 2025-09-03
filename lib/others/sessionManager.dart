// ======================================================
// SessionManager: Manejo de sesiones locales
// Maneja: guardado, obtención y limpieza de sesiones por rol
// ======================================================

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // ------------------------------
  // 🔹 Variables locales por rol
  // ------------------------------
  static String? adminUsername;
  static String? doctorUsername;
  static String? userUsername;

  // ------------------------------
  // 🔹 Guardar sesión
  // ------------------------------
  static Future<void> saveSession(String role, String token, String username) async {
    final prefs = await SharedPreferences.getInstance();

    // Guardar en SharedPreferences
    await prefs.setString('token_$role', token);
    await prefs.setString('username_$role', username);

    // Guardar en variables locales según rol
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

  // ------------------------------
  // 🔹 Obtener token
  // ------------------------------
  static Future<String?> getToken(String role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token_$role');
  }

  // ------------------------------
  // 🔹 Obtener username
  // ------------------------------
  static Future<String?> getUsername(String role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username_$role');
  }

  // ------------------------------
  // 🔹 Limpiar sesión de un rol
  // ------------------------------
  static Future<void> clearSession(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_$role');
    await prefs.remove('username_$role');

    // Limpiar variable local
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

  // ------------------------------
  // 🔹 Limpiar todas las sesiones
  // ------------------------------
  static Future<void> clearAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = ['admin', 'doctor', 'user'];
    for (final role in roles) {
      await prefs.remove('token_$role');
      await prefs.remove('username_$role');
    }

    // Limpiar variables locales
    adminUsername = null;
    doctorUsername = null;
    userUsername = null;
  }

  // ------------------------------
  // 🔹 Verificar si hay sesión activa
  // ------------------------------
  static Future<bool> isLoggedIn(String role) async {
    final token = await getToken(role);
    return token != null && token.isNotEmpty;
  }
}
