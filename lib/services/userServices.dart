import 'package:mioxy_frontend/models/user.dart';
import 'package:dio/dio.dart';
import 'package:mioxy_frontend/others/urlFile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mioxy_frontend/auth/tokenManager.dart';


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
      print('RESPUESTA: ${response}');
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

Future<int> editUser(String username,Map<String, dynamic> updatedFields) async {
    try {
      //Verificamos que tenemos token
      await _tokenManager.ensureTokenInitialized();

      // Obtener usuarios con paginación
      print('Obteniendo doctores desde el backend con paginación');
        Response response = await dio.put(
        '$baseUrl/users/editUser/$username',
        data: updatedFields,
        options: Options(
          headers: {
            'Authorization': "Bearer ${_tokenManager.token!}",
            //'Token': _tokenManager.token!, // 🔐 Token desde memoria
          },
        ),
      );

     
    print("✅ Respuesta completa del servidor: ${ response.data}");

  if (response.statusCode == 201) {
        print('Usuario actualizado');
        return 201;
      } else {
        print('Error en la edicióm: ${response.statusCode}');
        return response.statusCode!;
      }
}
catch(e){print('Excepción en la edición: $e');
      return -1;}}


Future<UserModel> getUser(String username) async {
    try {
      //Verificamos que tenemos token
      await _tokenManager.ensureTokenInitialized();

      // Obtener usuarios con paginación
      print('Obteniendo doctores desde el backend con paginación');
        Response response = await dio.get(
        '$baseUrl/users/getUser/$username',
        options: Options(
          headers: {
            'Authorization': "Bearer ${_tokenManager.token!}",
            //'Token': _tokenManager.token!, // 🔐 Token desde memoria
          },
        ),
      );

     
    print("✅ Respuesta completa del servidor: ${ response.data}");
    print("✅ Respuesta completa del servidor: ${ response.data}");

  if (response.statusCode == 200) {
        print('Usuario actualizado');
        // Suponiendo que UserModel tiene un fromJson
      return UserModel.fromJson(response.data);
      } else {
            throw Exception('Error al obtener usuario: ${response.statusCode}');

      }
}
catch(e){print('Excepción en getUser: $e');
    throw Exception('Error en la petición de usuario');}}




Future<int> updatePassword (Map<String, dynamic> fields) async {
    try {
      //Verificamos que tenemos token
      //await _tokenManager.ensureTokenInitialized();

      // Obtener usuarios con paginación
      print('Obteniendo doctores desde el backend con paginación');
        Response response = await dio.post(
        '$baseUrl/users/resetPassword',
        data: fields,
        options: Options(
          headers: {
            //'Authorization': "Bearer ${_tokenManager.token!}",
            //'Token': _tokenManager.token!, // 🔐 Token desde memoria
          },
        ),
      );

     
    print("✅ Respuesta completa del servidor: ${ response.data}");

  if (response.statusCode == 201) {
        print('Usuario actualizado');
        return 201;
      } else {
        print('Error en la edicióm: ${response.statusCode}');
        return response.statusCode!;
      }
}
catch(e){print('Excepción en la edición: $e');
      return -1;}}




    Future<int> logOut() async {
    try {
      print('Enviando solicitud de LogIn');
      Response response = await dio.post(
        '$baseUrl/users/logout',
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
