// ------------------------------------------------------------
// TokenManager: Manejo de JWT en Flutter con SharedPreferences
// ------------------------------------------------------------
// Este módulo gestiona:
// - Guardar, recuperar y eliminar el token JWT
// - Singleton opcional para mantener estado global
// - Inicialización perezosa del token desde SharedPreferences
// ------------------------------------------------------------

import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  // Token en memoria
  String? token;

  // ------------------------------------------------------------
  // Patrón Singleton (opcional)
  // Permite acceder a la misma instancia en toda la app
  // ------------------------------------------------------------
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  // ------------------------------------------------------------
  // Inicializa el token en memoria si aún no está cargado
  // ------------------------------------------------------------
  Future<void> ensureTokenInitialized() async {
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception("Token no encontrado, por favor loguearse");
      }
    } else {
      print("Token encontrado en memoria");
    }
  }

  // ------------------------------------------------------------
  // Guardar token en memoria y en SharedPreferences
  // ------------------------------------------------------------
  Future<void> setToken(String newToken) async {
    token = newToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', newToken);
  }

  // ------------------------------------------------------------
  // Recuperar token (garantiza que esté inicializado primero)
  // ------------------------------------------------------------
  Future<String> getToken() async {
    await ensureTokenInitialized();
    return token!;
  }

  // ------------------------------------------------------------
  // Cerrar sesión: elimina token de memoria y SharedPreferences
  // ------------------------------------------------------------
  Future<void> logout() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // ------------------------------------------------------------
  // Verifica si el token está cargado en memoria
  // ------------------------------------------------------------
  bool get isTokenInMemory => token != null;
}
