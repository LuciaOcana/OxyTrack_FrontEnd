//V1.2

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mioxy_frontend/controllers/navBarController.dart';

class BottomNavScaffold extends StatelessWidget {
  final Widget child;
  final NavBarController navController = Get.put(NavBarController());

  BottomNavScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    // Variables de tipo String asignadas en tiempo de ejecución
    final homeLabel = 'Home'.tr;
    final profileLabel = 'Perfil'.tr;

    return Scaffold(
      body: child,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: (index) {
            if (index == 2) {
              // Índice correspondiente al chat
              Get.toNamed('/chat'); // Navegar a la lista de usuarios
            } else {
              navController.navigateTo(index); // Navegar a otras pantallas
            }
          },
          elevation: 5, // Sombra suave para el diseño
          type: BottomNavigationBarType
              .fixed, // Fija para mantener los elementos en su lugar
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: homeLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: profileLabel,
            ),
          ],
        ),
      ),
    );
  }
}
