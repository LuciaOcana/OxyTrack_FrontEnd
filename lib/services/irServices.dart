import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:oxytrack_frontend/others/sessionManager.dart';

// Clase que representa un dato de SpO2
class SpO2Data {
  final double time;
  final double value;
    final DateTime timestamp; // NUEVO: hora real del dato
  SpO2Data(this.time, this.value, this.timestamp);

}

class IrService {
  // -------------------- SINGLETON --------------------
  static final IrService _instance = IrService._internal();
  factory IrService() => _instance;
  IrService._internal();
  // ---------------------------------------------------

  final String wsUrl = 'ws://192.168.1.48:3000';
  WebSocket? _socket;

  // StreamController broadcast para que múltiples listeners puedan escuchar
  final StreamController<Map<String, dynamic>> _spo2Controller =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get spo2Stream => _spo2Controller.stream;

  // Lista global de datos y estado actual
  List<SpO2Data> spo2Data = [];
  double timeIndex = 0;
  double? currentSpo2;
    DateTime? lastTimestamp; // NUEVO: último timestamp recibido


  // Conectar al WebSocket
  Future<void> connect() async {
    try {
      String? username = await SessionManager.getUsername();
      print("Conectando a WebSocket en: $wsUrl");

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

      final initMessage = jsonEncode({
        "type": "init",
        "username": username,
        "role": "paciente",
      });
      _socket!.add(initMessage);
      print("📤 Init enviado con username: $username");

      _socket!.listen(
        (data) {
          print('📨 Mensaje recibido WS: $data');
          try {
            Map<String, dynamic> message = jsonDecode(data);

            if (message.containsKey('spo2')) {
              double spo2Value = (message['spo2'] as num).toDouble();
              currentSpo2 = spo2Value;

// Parsear timestamp
      DateTime timestamp = DateTime.parse(message['timestamp']);
      
// Guardar último timestamp para mostrar debajo del %SpO2
      lastTimestamp = timestamp;
              // Guardar en lista global
              spo2Data.add(SpO2Data(timeIndex++, spo2Value,timestamp));

              // Mantener solo los últimos 100 datos para no crecer indefinidamente
              if (spo2Data.length > 100) {
                spo2Data.removeAt(0);
              }
            }

            _spo2Controller.add(message); // enviar al stream
          } catch (e) {
            print('❌ Error parseando mensaje WS: $e');
          }
        },
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

  // Enviar mensaje al backend
  void sendMessage(String message) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      _socket!.add(message);
    } else {
      print('⚠️ WebSocket no conectado para enviar mensaje');
    }
  }

  // Cerrar conexión y stream
  void disconnect() {
    _socket?.close();
    _socket = null;
    // No cerramos el stream aquí para mantener los datos mientras la app está abierta
    print('🔒 WebSocket desconectado (stream sigue activo)');
  }
}
