// ------------------------------------------------------------
// NavBarAdminController: Controlador para la barra de navegación
// de la sección de administración
// ------------------------------------------------------------
// Funciones principales:
// - Mantener índice seleccionado de la barra de navegación
// - Navegar entre rutas de la sección admin
// ------------------------------------------------------------

import 'package:get/get.dart';

class NavBarAdminController extends GetxController {
  // ------------------------------
  // Índice seleccionado actualmente
  // ------------------------------
  var selectedIndex = 0.obs; // Observable para actualizar la UI automáticamente

  // ------------------------------
  // Rutas disponibles en la barra de navegación
  // ------------------------------
  final List<String> routes = [
    '/adminDoctorListPage', // Página de listado de doctores
    '/adminAddDoctorPage'   // Página para agregar un doctor
  ];

  // ------------------------------------------------------------
  // Cambiar la ruta seleccionada y navegar
  // ------------------------------------------------------------
  void navigateTo(int index) {
    selectedIndex.value = index;   // Actualiza el índice seleccionado
    Get.offNamed(routes[index]);   // Navega a la ruta correspondiente
  }
}
