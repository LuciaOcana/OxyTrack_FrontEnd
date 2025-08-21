// lib/services/userDoctorServices.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:oxytrack_frontend/models/user.dart';

import 'package:oxytrack_frontend/models/userDoctor.dart';
import 'package:oxytrack_frontend/others/sessionManager.dart';
import 'package:oxytrack_frontend/others/urlFile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:oxytrack_frontend/auth/tokenManager.dart';

class UserDoctorServices {
  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) => status! < 500,
      followRedirects: true,
      maxRedirects: 5,
    ),
  );

  final TokenManager _tokenManager = TokenManager();

  // ----------------- 🔌 WEBSOCKET -----------------
  final String wsUrl = 'ws://192.168.1.51:3000/doctor'; // Ajusta IP
  WebSocket? _socket;

  String? _loggedDoctor; // variable no final, permite asignar null al desconectarse

  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get notificationsStream =>
      _notificationController.stream;


 Future<void> connectWS() async {
  try {
     // Verificar que haya doctor logueado
      final loggedDoctor = SessionManager.doctorUsername;
      print("$loggedDoctor");
      if (loggedDoctor == null) {
        print("⚠️ No hay doctor logueado en sesión. Conexión WS cancelada.");
        return;
      }

    _socket = await WebSocket.connect(wsUrl);
    print('🔌 WebSocket Doctor conectado como $_loggedDoctor');

    // Enviar auth inicial
    final authMsg = {
      "type": "init",
      "username": loggedDoctor,
      "role": "doctor",
    };
    _socket!.add(jsonEncode(authMsg));

    // Escuchar mensajes
    _socket!.listen(
      (data) {
        print('📩 WS Doctor mensaje: $data');
        try {
          final msg = jsonDecode(data);

          // 🔍 Filtrar mensajes solo para el doctor logueado
          final msgTarget = msg["target"]?.toString().trim();
        // Comparar directamente con SessionManager
            final currentDoctor = SessionManager.doctorUsername?.trim();
            if (currentDoctor != null && msgTarget == currentDoctor) {
              print("✅ Notificación válida para $currentDoctor: $msg");
              _notificationController.add(msg);
          } else {
            print(
              "⚠️ Notificación ignorada (target: $msgTarget, logged: $currentDoctor)"
            );
          }
        } catch (e) {
          print('❌ Error parseando mensaje WS Doctor: $e');
        }
      },
      onDone: () {
        print('🔒 WebSocket Doctor cerrado');
        _socket = null;
      },
      onError: (error) {
        print('❌ Error WebSocket Doctor: $error');
        _socket = null;
      },
    );
  } catch (e) {
    print('❌ No se pudo conectar al WebSocket Doctor: $e');
  }
}

  void sendWSMessage(Map<String, dynamic> msg) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      _socket!.add(jsonEncode(msg));
    } else {
      print('⚠️ WebSocket Doctor no conectado para enviar mensaje');
    }
  }

  void disconnectWS() {
    _socket?.close();
    _notificationController.close();
    _loggedDoctor = null; // permitimos borrar la sesión en memoria

    print("👋 WebSocket Doctor desconectado");
  }

  // ----------------- 🔐 REST API -----------------

  // Login de doctor
  Future<int> logInDoctor(logInDoctor) async {
    try {
      print('Enviando solicitud de LogIn Doctor');
      Response response = await dio.post(
        '$baseUrl/doctors/doctorLogin',
        data: logInDoctorJson(logInDoctor),
      );
      print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _tokenManager.setToken(token); // Guarda token automáticamente
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
  Future<List<UserModel>> getUsers({
    int page = 1,
    int limit = 20,
    bool connectedOnly = false,
  }) async {
    try {
      await _tokenManager
          .ensureTokenInitialized(); // Obtener usuarios con paginación
      print('Obteniendo usuarios desde el backend con paginación');

      var res = await dio.get(
        '$baseUrl/doctors/getUsers/$page/$limit',
        options: Options(
          headers: {'Authorization': "Bearer ${_tokenManager.token!}"},
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
  //usuarios paginados

  Future<int> updatePassword(Map<String, dynamic> fields) async {
    try {
      // Obtener usuarios con paginación
      print('Obteniendo doctores desde el backend con paginación');
      Response response = await dio.post(
        '$baseUrl/doctors/resetPasswordDoctor',
        data: fields,
      );

      print("✅ Respuesta completa del servidor: ${response.data}");

      if (response.statusCode == 201) {
        print('Doctor actualizado');
        return 201;
      } else {
        print('Error en la edicióm: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Excepción en la edición: $e');
      return -1;
    }
  }

  Future<int> editUser(
    String username,
    Map<String, dynamic> updatedFields,
  ) async {
    try {
      //Verificamos que tenemos token
      await _tokenManager.ensureTokenInitialized();

      // Obtener usuarios con paginación
      print('Obteniendo doctores desde el backend con paginación');
      Response response = await dio.put(
        '$baseUrl/doctors/editUserDoctor/$username',
        data: updatedFields,
        options: Options(
          headers: {
            'Authorization': "Bearer ${_tokenManager.token!}",
            //'Token': _tokenManager.token!, // 🔐 Token desde memoria
          },
        ),
      );

      print("✅ Respuesta completa del servidor: ${response.data}");

      if (response.statusCode == 201) {
        print('Usuario actualizado');
        return 201;
      } else {
        print('Error en la edicióm: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Excepción en la edición: $e');
      return -1;
    }
  }

  Map<String, dynamic> logInDoctorJson(logInDoctor) => {
    'username': logInDoctor.username,
    'password': logInDoctor.password,
  };

  Future<int> logOut(logIn) async {
    try {
      print('Enviando solicitud de LogIn');
      Response response = await dio.post('$baseUrl/doctors/logout');

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
