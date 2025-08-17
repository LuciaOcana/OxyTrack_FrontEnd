import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage(); // Almacenamiento local
  var isDarkMode = false.obs;    // Estado reactivo del tema

  @override
  void onInit() {
    super.onInit();
    // Cargar el estado guardado del tema (por defecto: claro)
    isDarkMode.value = _storage.read('isDarkMode') ?? false;

    // Aplicar el tema guardado
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Cambiar entre claro y oscuro
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    // Guardar el nuevo estado
    _storage.write('isDarkMode', isDarkMode.value);

    // Aplicar el cambio
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Obtener el estado actual como entero (útil si lo necesitas)
  int get modeStatus => isDarkMode.value ? 1 : 0;
}
