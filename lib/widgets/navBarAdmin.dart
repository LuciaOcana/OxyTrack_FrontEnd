//V1.2

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/controllers/navBarAdminController.dart';

class BottomNavScaffoldAdmin extends StatelessWidget {
  final Widget child;
  final NavBarAdminController navController = Get.put(NavBarAdminController());

  BottomNavScaffoldAdmin({required this.child});

  @override
  Widget build(BuildContext context) {
    // Variables de tipo String asignadas en tiempo de ejecución
    final doctorListLabel = 'Lista de doctores'.tr;
    final doctorAddLabel = 'Añadir doctor'.tr;

    return Scaffold(
      body: child,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: (index) {
            if (index != 2) {
              
              navController.navigateTo(index); // Navegar a otras pantallas
            }
          },
          elevation: 5, // Sombra suave para el diseño
          type:
              BottomNavigationBarType
                  .fixed, // Fija para mantener los elementos en su lugar
          // 👇 Colores personalizados
          //selectedItemColor: const Color(0xFF0096C7), // color activo
          //unselectedItemColor: Colors.grey, // color inactivo
          //backgroundColor: Colors.white, // color de fondo
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: doctorListLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1),
              label: doctorAddLabel,
            ),
          ],
        ),
      ),
    );
  }
}

