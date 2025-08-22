/*import 'dart:async';
import 'dart:convert';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleListener {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  DiscoveredDevice? _device;
  late QualifiedCharacteristic _characteristic;

  StreamSubscription<ConnectionStateUpdate>? _connection;
  StreamSubscription<List<int>>? _notificationSubscription;

  final Uuid serviceUuid = Uuid.parse("f47ac10b-58cc-4372-a567-0e02b2c3d479");
  final Uuid characteristicUuid = Uuid.parse("9c858901-8a57-4791-81fe-4c455b099bc9");

  bool _pendingLogin = false; // 🔹 Login pendiente

  /// Escanea y conecta al dispositivo automáticamente
  Future<void> scanAndConnect() async {
    print("🔎 Escaneando dispositivos BLE...");
    await for (final device in _ble.scanForDevices(withServices: [serviceUuid])) {
      if (device.name.isNotEmpty) {
        _device = device;
        print("Dispositivo encontrado: ${device.name} (${device.id})");
        await connect(); // Conectar automáticamente
        break;
      }
    }
  }

  /// Conectar y suscribirse a notificaciones
  Future<void> connect() async {
    if (_device == null) return;

    _characteristic = QualifiedCharacteristic(
      deviceId: _device!.id,
      serviceId: serviceUuid,
      characteristicId: characteristicUuid,
    );

    // Conexión BLE con escucha de estado
    _connection = _ble.connectToDevice(
      id: _device!.id,
      connectionTimeout: const Duration(seconds: 10),
    ).listen((state) async {
      print("Estado conexión BLE: ${state.connectionState}");
      if (state.connectionState == DeviceConnectionState.connected) {
        print("✅ Conectado a $_device");

        // Enviar login pendiente si hubo log in antes de conectarse
        if (_pendingLogin) {
          await sendLogin();
          _pendingLogin = false;
        }
      }
    }, onError: (err) {
      print("❌ Error de conexión BLE: $err");
    });

    // Suscripción a notificaciones
    _notificationSubscription = _ble.subscribeToCharacteristic(_characteristic).listen((data) {
      final received = String.fromCharCodes(data);
      print("Datos recibidos: $received");
    }, onError: (err) {
      print("❌ Error en notificación BLE: $err");
    });
  }

  /// Enviar "1" al ESP32 para iniciar medición
  Future<void> sendLogin() async {
    if (_device == null) {
      print("⚠️ BLE no conectado, marcar login pendiente...");
      _pendingLogin = true;
      return;
    }

    try {
      await _ble.writeCharacteristicWithResponse(
        _characteristic,
        value: utf8.encode("1"),
      );
      print("✅ Login enviado al ESP32");
    } catch (e) {
      print("❌ Error enviando login al ESP32: $e");
    }
  }

  /// Desconectar y limpiar
  void disconnect() {
    _notificationSubscription?.cancel();
    _notificationSubscription = null;

    _connection?.cancel();
    _connection = null;

    _device = null;
    _pendingLogin = false;

    print("Desconectado del dispositivo BLE");
  }
}
*/