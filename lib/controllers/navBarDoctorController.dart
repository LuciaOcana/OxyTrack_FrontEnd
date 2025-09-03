// ------------------------------------------------------------
// NavBarDoctorController: Controlador para la barra de navegación
// de la sección de doctor
// ------------------------------------------------------------
// Funciones principales:
// - Mantener índice seleccionado de la barra de navegación
// - Navegar entre rutas de la sección de doctor
// ------------------------------------------------------------

import 'package:get/get.dart';

class NavBarDoctorController extends GetxController {
  // ------------------------------
  // Índice seleccionado actualmente
  // ------------------------------
  var selectedIndex = 0.obs; // Observable para actualizar la UI automáticamente

  // ------------------------------
  // Rutas disponibles en la barra de navegación
  // ------------------------------
  final List<String> routes = [
    '/doctorPatientListPage', // Página de lista de pacientes del doctor
    '/doctorEditDoctorPage',  // Página de edición de perfil del doctor
  ];

  // ------------------------------------------------------------
  // Cambiar la ruta seleccionada y navegar
  // ------------------------------------------------------------
  void navigateTo(int index) {
    selectedIndex.value = index;   // Actualiza el índice seleccionado
    Get.offNamed(routes[index]);   // Navega a la ruta correspondiente usando GetX
  }
}
