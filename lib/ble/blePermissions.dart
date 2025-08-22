// lib/others/blePermissions.dart
import 'package:permission_handler/permission_handler.dart';

Future<void> requestBLEPermissions() async {
  await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.locationWhenInUse
  ].request();
}
