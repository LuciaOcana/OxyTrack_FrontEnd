// ======================================================
// userDoctorServices.dart
// Servicios para CRUD y autenticación de doctores + WebSocket
// ======================================================

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mioxi_frontend/models/user.dart';
import 'package:mioxi_frontend/models/userDoctor.dart';
import 'package:mioxi_frontend/others/sessionManager.dart';
import 'package:mioxi_frontend/others/urlFile.dart';
import 'package:mioxi_frontend/auth/tokenManager.dart';

class UserDoctorServices {
  // -------------------- SINGLETON --------------------
  static final UserDoctorServices _instance = UserDoctorServices._internal();
  factory UserDoctorServices() => _instance;
  UserDoctorServices._internal();
  // ---------------------------------------------------

  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) => status! < 500,
      followRedirects: true,
      maxRedirects: 5,
    ),
  );

  final TokenManager _tokenManager = TokenManager();

  // ----------------- 🔌 WEBSOCKET -----------------
  WebSocket? _socket;
  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get notificationsStream =>
      _notificationController.stream;

  final String wsUrl = 'wss://172.20.10.5:3000/doctor';
  String? _loggedDoctor;

  Future<void> connectWS() async {
    try {
      final loggedDoctor = SessionManager.doctorUsername;
      if (loggedDoctor == null) {
        print("⚠️ No hay doctor logueado. Conexión WS cancelada.");
        return;
      }

      if (_socket != null && _socket!.readyState == WebSocket.open) {
        print("🔄 WebSocket ya conectado");
        return;
      }

      _socket = await WebSocket.connect(wsUrl);
      _loggedDoctor = loggedDoctor;
      print('🔌 WebSocket Doctor conectado como $_loggedDoctor');

      final authMsg = {
        "type": "init",
        "username": loggedDoctor,
        "role": "doctor",
      };
      _socket!.add(jsonEncode(authMsg));

      _socket!.listen(
        (data) {
          try {
            final msg = jsonDecode(data);
            final msgTarget = msg["target"]?.toString().trim();
            final currentDoctor = SessionManager.doctorUsername?.trim();
            if (currentDoctor != null && msgTarget == currentDoctor) {
              _notificationController.add(msg);
            }
          } catch (e) {
            print('❌ Error parseando mensaje WS: $e');
          }
        },
        onDone: () => _socket = null,
        onError: (error) => _socket = null,
      );
    } catch (e) {
      print('❌ No se pudo conectar al WebSocket: $e');
    }
  }

  void sendWSMessage(Map<String, dynamic> msg) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      _socket!.add(jsonEncode(msg));
    } else {
      print('⚠️ WS no conectado');
    }
  }

  void disconnectWS() {
    _socket?.close();
      _socket = null;
    _loggedDoctor = null;
    print("👋 WebSocket Doctor desconectado");
  }

  // ----------------- 🔐 REST API -----------------

  // Login doctor
  Future<int> logInDoctor(dynamic logInDoctor) async {
    try {
      final response = await dio.post(
        '$baseUrl/doctors/doctorLogin',
        data: logInDoctorJson(logInDoctor),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _tokenManager.setToken(token);
        return 200;
      } else {
        return response.statusCode!;
      }
    } catch (e) {
      print('Error en logInDoctor: $e');
      return -1;
    }
  }

  Map<String, dynamic> logInDoctorJson(dynamic logInDoctor) => {
        'username': logInDoctor.username,
        'password': logInDoctor.password,
      };

  // Obtener usuarios paginados
  Future<List<UserModel>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      await _tokenManager.ensureTokenInitialized();
      final userDoc = await SessionManager.getUsername("doctor");
      if (userDoc == null) return [];

      final res = await dio.get(
        '$baseUrl/doctors/getUsers/$userDoc/$page/$limit',
        options: Options(headers: {'Authorization': "Bearer ${_tokenManager.token!}"}),
      );

      final List<dynamic> responseData = res.data['users'];
      return responseData.map((data) => UserModel.fromJson(data)).toList();
    } catch (e) {
      print("Error al obtener usuarios: $e");
      return [];
    }
  }

  // Editar usuario
  Future<int> editUser(String username, Map<String, dynamic> updatedFields) async {
    try {
      await _tokenManager.ensureTokenInitialized();

      final response = await dio.put(
        '$baseUrl/doctors/editUserDoctor/$username',
        data: updatedFields,
        options: Options(headers: {'Authorization': "Bearer ${_tokenManager.token!}"}),
      );

      return response.statusCode == 201 ? 201 : response.statusCode!;
    } catch (e) {
      print('Excepción en editUser: $e');
      return -1;
    }
  }

  // Obtener doctor
  Future<UserDoctorModel> getDoctor(String username) async {
    try {
      await _tokenManager.ensureTokenInitialized();

      final response = await dio.get(
        '$baseUrl/doctors/getDoctor/$username',
        options: Options(headers: {'Authorization': "Bearer ${_tokenManager.token!}"}),
      );

      if (response.statusCode == 200) {
        return UserDoctorModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener doctor: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en getDoctor: $e');
      throw Exception('Error en la petición del doctor');
    }
  }

  // Actualizar contraseña del doctor
  Future<int> updatePassword(Map<String, dynamic> fields) async {
    try {
      final response = await dio.post(
        '$baseUrl/doctors/resetPasswordDoctor',
        data: fields,
      );

      return response.statusCode == 201 ? 201 : response.statusCode!;
    } catch (e) {
      print('Excepción en updatePassword: $e');
      return -1;
    }
  }

  // Logout doctor
  Future<int> logOut() async {
    try {
      final response = await dio.post(
        '$baseUrl/doctors/logout',
        options: Options(headers: {'Authorization': "Bearer ${_tokenManager.token!}"}),
      );

      if (response.statusCode == 200) {
        disconnectWS();
        return 200;
      } else {
        return response.statusCode!;
      }
    } catch (e) {
      print('Error en logout: $e');
      return -1;
    }
  }
}
