// lib/services/userDoctorServices.dart

import 'package:dio/dio.dart';
import 'package:oxytrack_frontend/models/user.dart';

import 'package:oxytrack_frontend/models/userDoctor.dart';
import 'package:oxytrack_frontend/others/urlFile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserDoctorServices {

   final Dio dio = Dio(BaseOptions(
    validateStatus: (status) => status! < 500,
    followRedirects: true,
    maxRedirects: 5,
  ));
 String? _token; // 🔐 Token en memoria

  // Método privado que asegura que el token está cargado
  Future<void> _ensureTokenInitialized() async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('jwt_token');
      if (_token == null) {
        // Si quieres que devuelva un error explícito, sino omite esta línea
        throw Exception("Token no encontrado, por favor loguearse");
      }
    }
  }

  // Guardar token (memoria + SharedPreferences)
  Future<void> _setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }


  // Login de doctor
  Future<int> logInDoctor(logInDoctor) async {
    try {
      print('Enviando solicitud de LogIn Doctor');
      Response response = await dio.post(
        '$baseUrl/doctors/doctorLogin',
        data: logInDoctorJson(logInDoctor)
      );
        print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');

      if (response.statusCode == 200) {
         final token = response.data['token'];
        await _setToken(token); // Guarda token automáticamente
        print('TOKEN: ${token}');
        return 200;
      } else {
        print('Error en logInDoctor: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Error en logInDoctor: $e');
      return -1;
    }
  }

  
  //usuarios paginados
  Future<List<UserModel>> getUsers(
      {int page = 1, int limit = 20, bool connectedOnly = false}) async {
    try {
await _ensureTokenInitialized();        // Obtener usuarios con paginación
        print('Obteniendo usuarios desde el backend con paginación');

        
        var res = await dio.get('$baseUrl/doctors/getUsers/$page/$limit', options: Options(
          headers: {
            'Token': _token!, // 🔐 Token desde memoria
          },
        ),
      );
         final List<dynamic> responseData = res.data['users'];
        // Convertir los datos en una lista de objetos UserModel
        print("🔍 Respuesta completa del servidor: ${res.data}");

        return responseData.map((data) => UserModel.fromJson(data)).toList();
        } catch (e) {
      print("Error al obtener usuarios: $e");
      throw e;
    }
  }

   Map<String, dynamic> logInDoctorJson(logInDoctor) => {
        'username': logInDoctor.username,
        'password': logInDoctor.password,
      };
}
