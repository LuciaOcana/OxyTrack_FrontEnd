// ======================================================
// userServices.dart
// Servicios para CRUD y autenticación de usuarios
// ======================================================

import 'package:dio/dio.dart';
import 'package:mioxi_frontend/models/user.dart';
import 'package:mioxi_frontend/others/urlFile.dart';
import 'package:mioxi_frontend/auth/tokenManager.dart';

class UserServices {
  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) => status! < 500,
      followRedirects: true,
      maxRedirects: 5,
    ),
  );

  final TokenManager _tokenManager = TokenManager();

  // -------------------------------
  // Crear usuario
  // -------------------------------
  Future<int> createUser(UserModel newUser) async {
    try {
      final response = await dio.post(
        '$baseUrl/users/create',
        data: newUser.toJson(),
      );
      print('Respuesta completa del servidor: ${response.data}');

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

  // -------------------------------
  // LogIn de usuario
  // -------------------------------
  Future<int> logIn(dynamic logIn) async {
    try {
      final response = await dio.post(
        '$baseUrl/users/logIn',
        data: logInJson(logIn),
      );
      print('Respuesta logIn: $response');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _tokenManager.setToken(token); // Guardar token localmente
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

  Map<String, dynamic> logInJson(dynamic logIn) => {
        'username': logIn.username,
        'password': logIn.password,
      };

  // -------------------------------
  // Editar usuario
  // -------------------------------
  Future<int> editUser(String username, Map<String, dynamic> updatedFields) async {
    try {
      await _tokenManager.ensureTokenInitialized();

      final response = await dio.put(
        '$baseUrl/users/editUser/$username',
        data: updatedFields,
        options: Options(headers: {
          'Authorization': "Bearer ${_tokenManager.token!}",
        }),
      );

      print("✅ Respuesta completa del servidor: ${response.data}");
      if (response.statusCode == 201) {
        print('Usuario actualizado');
        return 201;
      } else {
        print('Error en la edición: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Excepción en la edición: $e');
      return -1;
    }
  }

  // -------------------------------
  // Obtener usuario por username
  // -------------------------------
  Future<UserModel> getUser(String username) async {
    try {
      await _tokenManager.ensureTokenInitialized();

      final response = await dio.get(
        '$baseUrl/users/getUser/$username',
        options: Options(headers: {
          'Authorization': "Bearer ${_tokenManager.token!}",
        }),
      );

      print("✅ Respuesta completa del servidor: ${response.data}");

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en getUser: $e');
      throw Exception('Error en la petición de usuario');
    }
  }

  // -------------------------------
  // Actualizar contraseña
  // -------------------------------
  Future<int> updatePassword(Map<String, dynamic> fields) async {
    try {
      final response = await dio.post(
        '$baseUrl/users/resetPassword',
        data: fields,
      );

      print("✅ Respuesta completa del servidor: ${response.data}");

      if (response.statusCode == 201) {
        print('Contraseña actualizada');
        return 201;
      } else {
        print('Error en actualización de contraseña: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Excepción en updatePassword: $e');
      return -1;
    }
  }

  // -------------------------------
  // Cerrar sesión
  // -------------------------------
  Future<int> logOut() async {
    try {
      final response = await dio.post(
        '$baseUrl/users/logout',
        options: Options(headers: {
          'Authorization': "Bearer ${_tokenManager.token!}",
        }),
      );

      if (response.statusCode == 200) {
        return 200;
      } else {
        print('Error en logout: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Excepción en logOut: $e');
      return -1;
    }
  }
}
