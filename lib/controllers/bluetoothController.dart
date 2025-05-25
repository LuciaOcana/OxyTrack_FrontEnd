import 'dart:convert';
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:http/http.dart' as http;

final flutterReactiveBle = FlutterReactiveBle();

final serviceUuid = Uuid.parse("f47ac10b-58cc-4372-a567-0e02b2c3d479");
final characteristicUuid = Uuid.parse("9c858901-8a57-4791-81fe-4c455b099bc9");

class BluetoothController {
  DiscoveredDevice? connectedDevice;
  QualifiedCharacteristic? characteristic;

  StreamSubscription<DiscoveredDevice>? _scanSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  StreamSubscription<List<int>>? _notificationSubscription;

  final _deviceStateController = StreamController<DiscoveredDevice?>();
  final _receivedDataController = StreamController<String>();

  Stream<DiscoveredDevice?> get deviceStateStream => _deviceStateController.stream;
  Stream<String> get receivedDataStream => _receivedDataController.stream;

  void scanAndConnect() {
    print("🔍 Escaneando dispositivos BLE...");
    _scanSubscription = flutterReactiveBle
        .scanForDevices(withServices: [serviceUuid], scanMode: ScanMode.lowLatency)
        .listen((device) {
      if (device.name == "ESP32-C3_BTLE") {
        print("📡 Dispositivo encontrado: ${device.name}");
        _scanSubscription?.cancel();

        _connectionSubscription = flutterReactiveBle
            .connectToDevice(id: device.id)
            .listen((connectionState) {
          if (connectionState.connectionState == DeviceConnectionState.connected) {
            print("✅ Conectado a ${device.name}");
            connectedDevice = device;
            characteristic = QualifiedCharacteristic(
              serviceId: serviceUuid,
              characteristicId: characteristicUuid,
              deviceId: device.id,
            );

            _deviceStateController.add(connectedDevice);

            _notificationSubscription = flutterReactiveBle
                .subscribeToCharacteristic(characteristic!)
                .listen((data) {
              final value = utf8.decode(data);
              print("📥 Dato BLE recibido: $value");
              _receivedDataController.add(value);
              sendDataToBackend(value);
            });
          } else if (connectionState.connectionState == DeviceConnectionState.disconnected) {
            print("⚠️ Dispositivo desconectado");
            connectedDevice = null;
            _deviceStateController.add(null);
          }
        }, onError: (err) {
          print("❌ Error de conexión: $err");
          connectedDevice = null;
          _deviceStateController.add(null);
        });
      }
    }, onError: (err) {
      print("❌ Error de escaneo: $err");
    });
  }

  Future<void> sendDataToBackend(String message) async {
    try {
      final response = await http.post(
        Uri.parse("https://TU_BACKEND.com/api/recibir-dato"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mensaje': message}),
      );

      if (response.statusCode == 200) {
        print("✅ Mensaje enviado al backend");
      } else {
        print("❌ Error al enviar al backend: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error HTTP: $e");
    }
  }

  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    _notificationSubscription?.cancel();
    _deviceStateController.close();
    _receivedDataController.close();
  }
}
