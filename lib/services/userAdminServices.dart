// ======================================================
// userAdminServices.dart
// Servicios para CRUD y autenticación de administradores
// ======================================================

import 'package:dio/dio.dart';
import 'package:mioxi_frontend/models/userAdmin.dart';
import 'package:mioxi_frontend/models/userDoctor.dart';
import 'package:mioxi_frontend/others/urlFile.dart';
import 'package:mioxi_frontend/auth/tokenManager.dart';

class UserAdminServices {
  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) => status! < 500,
      followRedirects: true,
      maxRedirects: 5,
    ),
  );

  final TokenManager _tokenManager = TokenManager();

  // ----------------- 🔐 AUTENTICACIÓN -----------------

  Future<int> logIn(dynamic logIn) async {
    try {
      final response = await dio.post(
        '$baseUrl/admin/logInAdmin',
        data: logInJson(logIn),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _tokenManager.setToken(token);
        return 200;
      } else {
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

  Future<int> logOut() async {
    try {
      final response = await dio.post(
        '$baseUrl/admin/logout',
        options: Options(
          headers: {'Authorization': "Bearer ${_tokenManager.token!}"},
        ),
      );

      return response.statusCode == 200 ? 200 : response.statusCode!;
    } catch (e) {
      print('Error en logout: $e');
      return -1;
    }
  }

  // ----------------- 🔄 CRUD DOCTOR -----------------

  Future<int> createDoctor(UserDoctorModel newDoctor) async {
    try {
      await _tokenManager.ensureTokenInitialized();

      final response = await dio.post(
        '$baseUrl/admin/createDoctor',
        data: newDoctor.toJson(),
        options: Options(headers: {'Authorization': "Bearer ${_tokenManager.token!}"}),
      );

      return response.statusCode == 201 ? 201 : response.statusCode!;
    } catch (e) {
      print('Excepción en createDoctor: $e');
      return -1;
    }
  }

  Future<int> editDoctor(String username, Map<String, dynamic> updatedFields) async {
    try {
      await _tokenManager.ensureTokenInitialized();

      final response = await dio.put(
        '$baseUrl/admin/editDoctorAdmin/$username',
        data: updatedFields,
        options: Options(headers: {'Authorization': "Bearer ${_tokenManager.token!}"}),
      );

      return response.statusCode == 201 ? 201 : response.statusCode!;
    } catch (e) {
      print('Excepción en editDoctor: $e');
      return -1;
    }
  }

  Future<List<UserDoctorModel>> getDoctors({int page = 1, int limit = 20}) async {
    try {
      await _tokenManager.ensureTokenInitialized();

      final response = await dio.get(
        '$baseUrl/admin/getDoctors/$page/$limit',
        options: Options(headers: {'Authorization': "Bearer ${_tokenManager.token!}"}),
      );

      final List<dynamic> responseData = response.data['doctors'] ?? [];
      return responseData.map((data) => UserDoctorModel.fromJson(data)).toList();
    } catch (e) {
      print('Error al obtener doctores: $e');
      return [];
    }
  }

  // Obtener lista de usuarios sin doctor asignado
  Future<List<String>> getUsersWNDoctor() async {
    try {
      await _tokenManager.ensureTokenInitialized();

      final response = await dio.get(
        '$baseUrl/admin/getUsers',
        options: Options(headers: {'Authorization': "Bearer ${_tokenManager.token!}"}),
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data["usersWNDoctor"] is List) {
        final users = data["usersWNDoctor"] as List<dynamic>;
        return users
            .whereType<Map<String, dynamic>>()
            .map((u) => "${u['name']} ${u['lastname']} (${u['username']})")
            .toList();
      }
      return [];
    } catch (e) {
      print('Error al obtener usuarios sin doctor: $e');
      return [];
    }
  }
}
