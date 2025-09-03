// ======================================================
// bottomNavScaffoldAdmin.dart
// Scaffold con BottomNavigationBar para Admin usando GetX
// Navegación entre Lista de doctores y Añadir doctor
// ======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mioxi_frontend/controllers/navBarAdminController.dart';

class BottomNavScaffoldAdmin extends StatelessWidget {
  /// Contenido principal del Scaffold
  final Widget child;

  /// Controlador de navegación para admin
  final NavBarAdminController navController = Get.put(NavBarAdminController());

  BottomNavScaffoldAdmin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Etiquetas traducibles
    final doctorListLabel = 'Lista de doctores'.tr;
    final doctorAddLabel = 'Añadir doctor'.tr;

    return Scaffold(
      body: child,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: (index) {
            // Navegación estándar
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
              label: doctorListLabel,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_add_alt_1),
              label: doctorAddLabel,
            ),
          ],
        ),
      ),
    );
  }
}
