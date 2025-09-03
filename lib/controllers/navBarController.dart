// ------------------------------------------------------------
// NavBarController: Controlador para la barra de navegación
// de la sección de usuario
// ------------------------------------------------------------
// Funciones principales:
// - Mantener índice seleccionado de la barra de navegación
// - Navegar entre rutas de la sección de usuario
// ------------------------------------------------------------

import 'package:get/get.dart';

class NavBarController extends GetxController {
  // ------------------------------
  // Índice seleccionado actualmente
  // ------------------------------
  var selectedIndex = 0.obs; // Observable para actualizar la UI automáticamente

  // ------------------------------
  // Rutas disponibles en la barra de navegación
  // ------------------------------
  final List<String> routes = [
    '/homeUser',    // Página principal del usuario
    '/profileUser', // Página de perfil del usuario
  ];

  // ------------------------------------------------------------
  // Cambiar la ruta seleccionada y navegar
  // ------------------------------------------------------------
  void navigateTo(int index) {
    selectedIndex.value = index;   // Actualiza el índice seleccionado
    Get.offNamed(routes[index]);   // Navega a la ruta correspondiente usando GetX
  }
}
