import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mioxi_frontend/controllers/userAdminController.dart';
import 'package:mioxi_frontend/controllers/doctorListController.dart';
import 'package:mioxi_frontend/widgets/doctorCard.dart';
import 'package:mioxi_frontend/others/themeController.dart';

class AdminDoctorListPageScreen extends StatefulWidget {
  const AdminDoctorListPageScreen({super.key});

  @override
  State<AdminDoctorListPageScreen> createState() =>
      _AdminDoctorListPageScreenState();
}

class _AdminDoctorListPageScreenState extends State<AdminDoctorListPageScreen> {
  final UserAdminController _userAdminController = UserAdminController();
  final DoctorListController _doctorListController = DoctorListController();

  @override
  void initState() {
    super.initState();
    _doctorListController.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    // 🎨 Colores dinámicos
    final appBarColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final buttonColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final textColor = isLight ? Colors.black87 : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro médico'),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(isLight ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
          onPressed: () => Get.find<ThemeController>().toggleTheme(),
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFe2fdff)),
            tooltip: 'Cerrar sesión',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (_doctorListController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_doctorListController.doctorList.isEmpty) {
            return const Center(child: Text('No hay doctores disponibles.'));
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
      ),
      floatingActionButton: Obx(() {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'prev',
                    onPressed: _doctorListController.currentPage.value > 1
                        ? _doctorListController.previousPage
                        : null,
                    backgroundColor: _doctorListController.currentPage.value > 1
                        ? buttonColor
                        : (isLight ? Colors.grey[500]! : Colors.grey[700]!),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                    tooltip: 'Página anterior',
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: 'refresh',
                    onPressed: _doctorListController.fetchDoctors,
                    backgroundColor: buttonColor,
                    child: _doctorListController.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white))
                        : const Icon(Icons.refresh, color: Colors.white),
                    tooltip: 'Recargar lista',
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: 'next',
                    onPressed: _doctorListController.doctorList.length ==
                            _doctorListController.limit.value
                        ? _doctorListController.nextPage
                        : null,
                    backgroundColor: _doctorListController.doctorList.length ==
                            _doctorListController.limit.value
                        ? buttonColor
                        : (isLight ? Colors.grey[500]! : Colors.grey[700]!),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                    tooltip: 'Página siguiente',
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? Colors.black87 : Colors.white;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          "¿Estás seguro de que quieres cerrar sesión?",
          style: TextStyle(fontSize: 16, color: textColor, fontFamily: 'OpenSans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFE4E1)),
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
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB31B1B)),
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
      ),
    );
  }
}
