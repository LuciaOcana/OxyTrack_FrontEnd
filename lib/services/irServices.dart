import 'dart:async';
import 'dart:convert';
import 'dart:io';

class IrService {
  final String wsUrl = 'ws://192.168.1.46:5000'; // URL del WebSocket (ajusta IP y puerto)
  //final String baseUrl = "http://10.0.2.2:5000/api/users"; // Para Android Emulator
  //*final String baseUrl = "http://0.0.0.0:5000/api/users"; // Para Android Emulator

  WebSocket? _socket;
  StreamController<Map<String, dynamic>> _spo2Controller = StreamController.broadcast();

  // Stream para que la UI escuche cambios de SpO2
  Stream<Map<String, dynamic>> get spo2Stream => _spo2Controller.stream;

  // Abrir conexión WebSocket
  Future<void> connect() async {
    try {
      _socket = await WebSocket.connect(wsUrl);

      print('WebSocket conectado');

      _socket!.listen(
        (data) {
          print('Mensaje recibido WS: $data');

          try {
            // Suponiendo que el backend envía JSON con {username, spo2, timestamp}
            Map<String, dynamic> message = jsonDecode(data);
            _spo2Controller.add(message);  // Enviar datos al stream
          } catch (e) {
            print('Error parseando mensaje WS: $e');
          }
        },
        onDone: () {
          print('WebSocket cerrado');
          _socket = null;
        },
        onError: (error) {
          print('Error WebSocket: $error');
          _socket = null;
        },
      );
    } catch (e) {
      print('No se pudo conectar al WebSocket: $e');
    }
  }

  // Enviar mensaje (si quieres enviar algo al backend)
  void sendMessage(String message) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      _socket!.add(message);
    } else {
      print('WebSocket no conectado para enviar mensaje');
    }
  }

  // Cerrar la conexión WebSocket y el stream
  void disconnect() {
    _socket?.close();
    _spo2Controller.close();
  }
}
