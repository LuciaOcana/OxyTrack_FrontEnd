// ======================================================
// ThemeController: Manejo del tema de la aplicación
// Permite alternar entre modo claro y oscuro
// ======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  // ------------------------------
  // 🔹 Almacenamiento local
  // ------------------------------
  final _storage = GetStorage();

  // ------------------------------
  // 🔹 Estado reactivo del tema
  // ------------------------------
  var isDarkMode = false.obs;

  // ------------------------------
  // 🔹 Inicialización
  // ------------------------------
  @override
  void onInit() {
    super.onInit();
    
    // Cargar estado guardado (por defecto: claro)
    isDarkMode.value = _storage.read('isDarkMode') ?? false;

    // Aplicar el tema guardado
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  // ------------------------------
  // 🔹 Alternar tema
  // ------------------------------
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    // Guardar el nuevo estado
    _storage.write('isDarkMode', isDarkMode.value);

    // Aplicar el cambio
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  // ------------------------------
  // 🔹 Obtener el estado actual como entero
  // Útil si necesitas pasar el estado a otro lugar
  // ------------------------------
  int get modeStatus => isDarkMode.value ? 1 : 0;
}
