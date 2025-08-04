import 'package:oxytrack_frontend/models/user.dart';
import 'package:dio/dio.dart';
import 'package:oxytrack_frontend/others/urlFile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:oxytrack_frontend/auth/tokenManager.dart';


class UserServices {
  //final String baseUrl = "http://192.168.1.67:5000/api/users"; // Para Android Emulator
  //final String baseUrl = "http://10.0.2.2:5000/api/users"; // Para Android Emulator
    //*final String baseUrl = "http://0.0.0.0:5000/api/users"; // Para Android Emulator


  final Dio dio = Dio(BaseOptions(
    validateStatus: (status) => status! < 500,
    followRedirects: true,
    maxRedirects: 5,
  ));

  final TokenManager _tokenManager = TokenManager();

  /*String? _token; // 🔐 Token en memoria
  
  // Inicializar (leer token guardado en memoria al arrancar)
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
  }

  // Getter del token si necesitas exponerlo
  String? get token => _token;

  // Guardar token (memoria + SharedPreferences)
  Future<void> _setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Borrar token
  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
*/


// Método para registrarte
  Future<int> createUser(UserModel newUser) async {
    try {
      Response response = await dio.post(
        '$baseUrl/users/create',
        data: newUser.toJson(),
      );
      print('Respuesta completa del servidor: ${response.data}');
      print('Respuesta del servidor: ${response.statusCode}');
      
      if (response.statusCode == 201) {
        print('Usuario creado.');
        return 201;
      } else {
        print('Error en creación: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Excepción en creación: $e');
      return -1;
    }
  }

  Future<int> logIn(logIn) async {
    try {
      print('Enviando solicitud de LogIn');
      Response response = await dio.post(
        '$baseUrl/users/logIn',
        data: logInJson(logIn),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _tokenManager.setToken(token); // ✅ Guardar token
        return 200;
      } else {
        print('Error en logIn: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Error en logIn: $e');
      return -1;
    }
  }


    Map<String, dynamic> logInJson(logIn) => {
        'username': logIn.username,
        'password': logIn.password,
      };
}
