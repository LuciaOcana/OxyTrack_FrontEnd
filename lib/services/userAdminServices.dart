import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:oxytrack_frontend/models/userAdmin.dart';
import 'package:oxytrack_frontend/models/userDoctor.dart';
import 'package:oxytrack_frontend/others/urlFile.dart';

import 'package:oxytrack_frontend/auth/tokenManager.dart';

class UserAdminServices {
  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) => status! < 500,
      followRedirects: true,
      maxRedirects: 5,
    ),
  );

  final TokenManager _tokenManager = TokenManager();

  Future<int> logIn(logIn) async {
    try {
      print('Enviando solicitud de LogIn');
      Response response = await dio.post(
        '$baseUrl/admin/logInAdmin',
        data: logInJson(logIn),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _tokenManager.setToken(token); // Guarda token automáticamente
        print('TOKEN: ${token}');
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

  // Crear doctor
  Future<int> createDoctor(UserDoctorModel newDoctor) async {
    try {
      await _tokenManager.ensureTokenInitialized();

      Response response = await dio.post(
        '$baseUrl/admin/createDoctor',
        data: newDoctor.toJson(),
        options: Options(
          headers: {
             'Authorization': "Bearer ${_tokenManager.token!}",
            //'Token': _tokenManager.token!, // 🔐 Token desde memoria
          },
        ),
      );

      print('Respuesta completa del servidor: ${response.data}');
      print('Respuesta del servidor: ${response.statusCode}');
      if (response.statusCode == 201) {
        print('Doctor creado.');
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

  //usuarios paginados
  Future<List<UserDoctorModel>> getDoctors({
    int page = 1,
    int limit = 20,
    bool connectedOnly = false,
  }) async {
    try {
      await _tokenManager.ensureTokenInitialized();

      // Obtener usuarios con paginación
      print('Obteniendo doctores desde el backend con paginación');
      var res = await dio.get(
        '$baseUrl/admin/getDoctors/$page/$limit',
        options: Options(
          headers: {
            "Authorization": "Bearer $_tokenManager.token!",
            //'Token': _tokenManager.token!, // 🔐 Token desde memoria
          },
        ),
      );
      final List<dynamic> responseData = res.data['doctors'];
      // Convertir los datos en una lista de objetos UserModel
      print("🔍 Respuesta completa del servidor: ${res.data}");

      return responseData
          .map((data) => UserDoctorModel.fromJson(data))
          .toList();
    } catch (e) {
      print("Error al obtener doctores: $e");
      throw e;
    }
  }

  //usuarios paginados
  Future<List<String>> getUsersWNDoctor() async {
    try {
      //Verificamos que tenemos token
      await _tokenManager.ensureTokenInitialized();

      // Obtener usuarios con paginación
      print('Obteniendo doctores desde el backend con paginación');
      var res = await dio.get(
        '$baseUrl/admin/getUsers',
        options: Options(
          headers: {
            'Authorization': "Bearer ${_tokenManager.token!}",
            //'Token': _tokenManager.token!, // 🔐 Token desde memoria
          },
        ),
      );

      final responseData = res.data;
      // Convertir los datos en una lista de objetos UserModel
      print("🔍 Respuesta completa del servidor: ${res.data}");

      if (responseData is Map<String, dynamic> &&
          responseData["usersWNDoctor"] is List) {
        final List<dynamic> users = responseData["usersWNDoctor"];

        // En este caso users es directamente ["Lucia Ocana", "Otro Usuario", ...]
        final names = users.map((u) => u.toString()).toList();

        // Logs de verificación
        for (var name in names) {
          print("👤 Usuario encontrado: $name");
        }

        return names;
      }

      return [];
    } catch (e) {
      print("Error al obtener doctores: $e");
      throw e;
    }
  }

  Future<int> logOut() async {
    try {
      print('Enviando solicitud de LogIn');
      Response response = await dio.post(
        '$baseUrl/admin/logout',
        options: Options(
          headers: {
            "Authorization": "Bearer $_tokenManager.token!",
            //'Token': _tokenManager.token!, // 🔐 Token desde memoria
          },
        ),
      );

      if (response.statusCode == 200) {
        return 200;
      } else {
        print('Error en logout: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Error en logout: $e');
      return -1;
    }
  }
}
