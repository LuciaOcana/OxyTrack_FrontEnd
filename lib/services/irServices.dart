// ======================================================
// irService.dart
// Servicio WebSocket para datos de SpO2
// ======================================================

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mioxi_frontend/others/sessionManager.dart';

// Clase que representa un dato de SpO2 con timestamp real
class SpO2Data {
  final double time;
  final double value;
  final DateTime timestamp;

  SpO2Data(this.time, this.value, this.timestamp);
}

class IrService {
  // -------------------- SINGLETON --------------------
  static final IrService _instance = IrService._internal();
  factory IrService() => _instance;
  IrService._internal();
  // ---------------------------------------------------

  final String wsUrl = 'wss://172.20.10.5:3000';
  WebSocket? _socket;

  // StreamController broadcast para múltiples listeners
  final StreamController<Map<String, dynamic>> _spo2Controller =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get spo2Stream => _spo2Controller.stream;

  // Estado global
  List<SpO2Data> spo2Data = [];
  double timeIndex = 0;
  double? currentSpo2;
  DateTime? lastTimestamp;

  // -------------------- CONEXIÓN --------------------
  Future<void> connect() async {
    try {
      final username = await SessionManager.getUsername("user");
      if (username == null || username.isEmpty) {
        print("❌ No se encontró username en sesión");
        return;
      }

      if (_socket != null && _socket!.readyState == WebSocket.open) {
        print("🔄 WebSocket ya está conectado");
        return;
      }

      _socket = await WebSocket.connect(wsUrl);
      print('✅ WebSocket conectado');

      // Enviar mensaje de inicialización
      _socket!.add(jsonEncode({
        "type": "init",
        "username": username,
        "role": "paciente",
      }));

      // Escuchar mensajes del WS
      _socket!.listen(
        _handleMessage,
        onDone: () {
          print('🔌 WebSocket cerrado');
          _socket = null;
        },
        onError: (error) {
          print('❌ Error WebSocket: $error');
          _socket = null;
        },
      );
    } catch (e) {
      print('❌ No se pudo conectar al WebSocket: $e');
    }
  }

  // -------------------- MENSAJES --------------------
  void _handleMessage(dynamic data) {
    try {
      final message = jsonDecode(data) as Map<String, dynamic>;
      print('📨 Mensaje recibido WS: $message');

      if (message.containsKey('spo2')) {
        final spo2Value = (message['spo2'] as num).toDouble();
        currentSpo2 = spo2Value;

        final timestamp = DateTime.parse(message['timestamp']);
        lastTimestamp = timestamp;

        spo2Data.add(SpO2Data(timeIndex++, spo2Value, timestamp));

        // Mantener solo últimos 100 datos
        if (spo2Data.length > 100) {
          spo2Data.removeAt(0);
        }
      }

      _spo2Controller.add(message);
    } catch (e) {
      print('❌ Error parseando mensaje WS: $e');
    }
  }

  void sendMessage(String message) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      _socket!.add(message);
    } else {
      print('⚠️ WebSocket no conectado para enviar mensaje');
    }
  }

  // -------------------- RESET Y DESCONECTAR --------------------
  void reset() {
    spo2Data.clear();
    currentSpo2 = null;
    lastTimestamp = null;
    timeIndex = 0;
    print('🗑️ Datos del IrService reseteados');
  }

  void disconnect() {
    _socket?.close();
    _socket = null;
    print('🔒 WebSocket desconectado (stream sigue activo)');
  }
}
