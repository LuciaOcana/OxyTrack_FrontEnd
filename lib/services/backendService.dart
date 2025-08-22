/*import 'dart:convert';
import 'dart:io';

class BackendService {
  final String backendUrl;
  WebSocket? _socket;
  bool _connected = false;

  // Usuario logueado (vacío si no hay login)
  String _loggedInUsername = '';

  // 🔹 Singleton
  BackendService._privateConstructor(this.backendUrl);
  static late BackendService instance;

  // Inicializar singleton
  static void init(String url) {
    instance = BackendService._privateConstructor(url);
  }

  /// Conecta al backend vía WebSocket
  Future<void> connect() async {
    try {
      _socket = await WebSocket.connect(backendUrl);
      _connected = true;
      print("✅ Conectado al backend");

      // Escuchar mensajes del backend
      _socket!.listen(
        _handleMessage,
        onDone: () {
          print("⚠️ Conexión cerrada");
          _connected = false;
          _reconnect();
        },
        onError: (e) {
          print("❌ Error WebSocket: $e");
          _connected = false;
          _reconnect();
        },
      );
    } catch (e) {
      print("❌ No se pudo conectar al backend: $e");
      _connected = false;
      _reconnect();
    }
  }

  /// Maneja mensajes recibidos del backend
  void _handleMessage(dynamic message) {
    print("🔹 Mensaje del backend: $message");

    try {
      final Map<String, dynamic> data = jsonDecode(message);
      if (data.containsKey('loginStatus')) {
        print("⚡ Backend solicita loginStatus: ${data['loginStatus']}");
      }
    } catch (e) {
      print("⚠️ Error parseando mensaje: $e");
    }
  }

  /// Establece el usuario logueado
  void setLoggedInUser(String username) {
    _loggedInUsername = username;
    print("👤 Usuario logueado establecido: $_loggedInUsername");
  }

  /// Envía datos IR y RED al backend solo si hay usuario logueado
  void sendIrRedData({required int ir, required int red}) {
    if (_loggedInUsername.isEmpty) {
      print("⚠️ No hay usuario logueado. Datos IR/RED no enviados.");
      return;
    }

    if (_connected && _socket != null) {
      final payload = {
        "username": _loggedInUsername,
        "ir": ir,
        "red": red,
        "timestamp": DateTime.now().toIso8601String(),
      };
      _socket!.add(jsonEncode(payload));
      print("📤 Datos enviados al backend: IR=$ir, RED=$red");
    } else {
      print("⚠️ No conectado, datos no enviados");
    }
  }

  /// Reintento automático si la conexión falla
  void _reconnect() async {
    await Future.delayed(Duration(seconds: 5));
    if (!_connected) {
      print("🔄 Intentando reconectar al backend...");
      await connect();
    }
  }

  /// Cierra la conexión al backend
  Future<void> disconnect() async {
    await _socket?.close();
    _connected = false;
    print("❌ Desconectado del backend");
  }
}*/
