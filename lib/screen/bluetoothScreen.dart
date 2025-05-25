import 'package:flutter/material.dart';
import 'package:oxytrack_frontend/controllers/bluetoothController.dart';

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final BluetoothController _controller = BluetoothController();

  String _statusText = "🔴 Desconectado (inicial)";
  String _receivedData = "";

  @override
  void initState() {
    super.initState();

    // Escucha cambios en el estado de conexión del dispositivo BLE
    _controller.deviceStateStream.listen((device) {
      setState(() {
        if (device != null) {
          _statusText = "🟡 Conectando a ${device.name}...";
        } else {
          _statusText = "🔴 Desconectado";
          _receivedData = "";
        }
      });
    });

    // Escucha los datos recibidos del microcontrolador
    _controller.receivedDataStream.listen((data) {
      setState(() {
        _receivedData = data;

        if (data.trim() == "1") {
          _statusText = "✅ Conectado";
        } else if (data.trim() == "0") {
          _statusText = "🔴 Desconectado";
        } else {
          _statusText = "⚠️ Estado desconocido: $data";
        }
      });
    });

    _controller.scanAndConnect();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth BLE')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusText,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              "Último dato recibido:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _receivedData,
              style: TextStyle(fontSize: 20, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
