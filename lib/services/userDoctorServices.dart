// lib/services/userDoctorServices.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:oxytrack_frontend/models/user.dart';

import 'package:oxytrack_frontend/models/userDoctor.dart';
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
  final String wsUrl = 'ws://192.168.1.48:5000/doctor'; // Ajusta IP
  WebSocket? _socket;

  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get notificationsStream =>
      _notificationController.stream;

  Future<void> connectWS(String doctorUsername) async {
    try {
      _socket = await WebSocket.connect(wsUrl);
      print('🔌 WebSocket Doctor conectado');

      // Enviar auth inicial
      final authMsg = {
        "type": "auth",
        "username": doctorUsername,
      };
      _socket!.add(jsonEncode(authMsg));

      // Escuchar mensajes
      _socket!.listen(
        (data) {
          print('📩 WS Doctor mensaje: $data');
          try {
            final msg = jsonDecode(data);
            _notificationController.add(msg);
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
  Future<int> newPassword(String username, String newPassword) async {
  try {
    await _tokenManager.ensureTokenInitialized();

    print('🔐 Enviando nueva contraseña para el usuario $username');

    var res = await dio.put(
      '$baseUrl/doctors/editPassDoctor/$username',
      data:  {'password': "$newPassword"}, // Enviar nueva contraseña
      options: Options(
        headers: {'Authorization': "Bearer ${_tokenManager.token!}"},
      ),
    );

    print("✅ Contraseña actualizada: ${res.data}");
    return 1;
  } catch (e) {
    print("❌ Error al actualizar la contraseña: $e");
    throw e;
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
