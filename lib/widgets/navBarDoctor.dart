// ======================================================
// bottomNavScaffoldDoctor.dart
// Scaffold con BottomNavigationBar para Doctor usando GetX
// Navegación entre Lista de pacientes y Editar doctor
// ======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mioxi_frontend/controllers/navBarDoctorController.dart';

class BottomNavScaffoldDoctor extends StatelessWidget {
  /// Contenido principal del Scaffold
  final Widget child;

  /// Controlador de navegación para doctor
  final NavBarDoctorController navController = Get.put(NavBarDoctorController());

  BottomNavScaffoldDoctor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Etiquetas traducibles
    final patientsListLabel = 'Lista de pacientes'.tr;
    final doctorEditLabel = 'Editar doctor'.tr;

    return Scaffold(
      body: child,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: (index) {
            // Solo navegación estándar, sin ruta especial
            if (index != 2) {
              navController.navigateTo(index);
            }
          },
          elevation: 5, // Sombra suave
          type: BottomNavigationBarType.fixed, // Mantiene los elementos fijos
          // Puedes personalizar colores aquí si lo deseas
          // selectedItemColor: const Color(0xFF0096C7),
          // unselectedItemColor: Colors.grey,
          // backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.list_alt),
              label: patientsListLabel,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_add_alt_1),
              label: doctorEditLabel,
            ),
          ],
        ),
      ),
    );
  }
}
