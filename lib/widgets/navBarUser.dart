// ======================================================
// bottomNavScaffold.dart
// Scaffold con BottomNavigationBar reactivo usando GetX
// Incluye navegación entre Home, Perfil y Chat
// ======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mioxi_frontend/controllers/navBarController.dart';

class BottomNavScaffold extends StatelessWidget {
  /// Contenido principal del Scaffold
  final Widget child;

  /// Controlador de navegación
  final NavBarController navController = Get.put(NavBarController());

  BottomNavScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Etiquetas traducibles
    final homeLabel = 'Home'.tr;
    final profileLabel = 'Perfil'.tr;

    return Scaffold(
      body: child,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: (index) {
            if (index == 2) {
              // Navegación especial: chat
              Get.toNamed('/chat');
            } else {
              // Navegación estándar
              navController.navigateTo(index);
            }
          },
          elevation: 5, // Sombra suave
          type: BottomNavigationBarType.fixed, // Mantiene los elementos fijos
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: homeLabel,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              label: profileLabel,
            ),
          ],
        ),
      ),
    );
  }
}
