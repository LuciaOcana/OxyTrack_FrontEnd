import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:oxytrack_frontend/controllers/userAdminController.dart';
import 'package:oxytrack_frontend/controllers/doctorListController.dart';

import 'package:oxytrack_frontend/models/userDoctor.dart';
import 'package:oxytrack_frontend/widgets/doctorCard.dart';

class AdminDoctorListPageScreen extends StatefulWidget {
  const AdminDoctorListPageScreen({super.key});

  @override
  State<AdminDoctorListPageScreen> createState() =>
      _AdminDoctorListPageScreenState();
}

class _AdminDoctorListPageScreenState
    extends State<AdminDoctorListPageScreen> {
  final UserAdminController _userAdminController = UserAdminController();
  final DoctorListController _doctorListController = DoctorListController();

  @override
  void initState() {
    super.initState();
    _doctorListController.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal médico registrado'),
        backgroundColor: const Color(0xFF0096C7),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Obx(() {
              if (_doctorListController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_doctorListController.doctorList.isEmpty) {
                return const Center(
                  child: Text('No hay doctores disponibles.'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _doctorListController.doctorList.length,
                itemBuilder: (context, index) {
                  final doctor = _doctorListController.doctorList[index];
                  return DoctorCard(doctor: doctor);
                },
              );
            }),
          ],
        ),
      ),
      // 🔹 Botones flotantes de recarga y paginación
     floatingActionButton: Obx(
  () => Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón "Anterior"
          FloatingActionButton(
            heroTag: 'prev',
            onPressed: _doctorListController.currentPage.value > 1
                ? _doctorListController.previousPage
                : null,
            backgroundColor: _doctorListController.currentPage.value > 1
                ? const Color(0xFF0096C7)
                : Colors.grey,
            child: const Icon(Icons.arrow_back),
            tooltip: 'Página anterior',
          ),
          const SizedBox(width: 16),
          // Botón de recarga
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: _doctorListController.fetchDoctors,
            backgroundColor: const Color(0xFF0096C7),
            child: _doctorListController.isLoading.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'Recargar lista',
          ),
          const SizedBox(width: 16),
          // Botón "Siguiente"
          FloatingActionButton(
            heroTag: 'next',
            onPressed: _doctorListController.doctorList.length ==
                    _doctorListController.limit.value
                ? _doctorListController.nextPage
                : null,
            backgroundColor:
                _doctorListController.doctorList.length ==
                        _doctorListController.limit.value
                    ? const Color(0xFF0096C7)
                    : Colors.grey,
            child: const Icon(Icons.arrow_forward),
            tooltip: 'Página siguiente',
          ),
        ],
      ),
    ),
  ),
),

    );
  }

  /// 🔹 Función para mostrar el pop up de confirmación
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Text(
            "¿Estás seguro de que quieres cerrar sesión?",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 0, 0, 0),
              fontFamily: 'OpenSans',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE4E1)),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFB31B1B),
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _userAdminController.logout();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB31B1B)),
              child: const Text(
                "Cerrar sesión",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFFFE4E1),
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
