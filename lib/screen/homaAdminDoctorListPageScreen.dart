import 'package:flutter/material.dart';
import 'package:get/get.dart';

//import 'package:oxytrack_frontend/widgets/userCard.dart'; // Importa el modelo de usuario
import 'package:oxytrack_frontend/controllers/userAdminController.dart';
import 'package:oxytrack_frontend/controllers/doctorListController.dart';

import 'package:oxytrack_frontend/models/userDoctor.dart';

import 'package:oxytrack_frontend/widgets/doctorCard.dart';

class AdminDoctorListPageScreen extends StatefulWidget {
  const AdminDoctorListPageScreen({super.key});

  @override
  State<AdminDoctorListPageScreen> createState() => _AdminDoctorListPageScreenState();
}

class _AdminDoctorListPageScreenState extends State<AdminDoctorListPageScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserAdminController _userAdminController = UserAdminController();
  final DoctorListController _doctorListController = Get.put(
    DoctorListController(),
  );
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Gestión de Doctores'),
      backgroundColor: Colors.lightBlueAccent,
      automaticallyImplyLeading: false, // 🔹 Quita la flecha atrás
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Doctores registrados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
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
  );
}

/// 🔹 Función para mostrar el pop up de confirmación
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("¿Estás seguro de que quieres cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el pop up
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              _userAdminController.logout();

              Navigator.of(context).pop(); // Cierra el pop up
              // 🔹 Aquí pones tu lógica de logout (ej: limpiar sesión, navegar al login)
              //Get.offAllNamed('/login'); 
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Cerrar sesión"),
          ),
        ],
      );
    },
  );
}
}