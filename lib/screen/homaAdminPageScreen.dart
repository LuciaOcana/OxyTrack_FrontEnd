import 'package:flutter/material.dart';
import 'package:get/get.dart';

//import 'package:oxytrack_frontend/widgets/userCard.dart'; // Importa el modelo de usuario
import 'package:oxytrack_frontend/controllers/userAdminController.dart';
import 'package:oxytrack_frontend/controllers/doctorListController.dart';

import 'package:oxytrack_frontend/models/userDoctor.dart';

import 'package:oxytrack_frontend/widgets/doctorCard.dart';

class AdminPageScreen extends StatefulWidget {
  const AdminPageScreen({super.key});

  @override
  State<AdminPageScreen> createState() => _AdminPageScreenState();
}

class _AdminPageScreenState extends State<AdminPageScreen> {
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Registro de doctores
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Registrar Doctor',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userAdminController.usernameDoctorController,
                    decoration: const InputDecoration(labelText: 'username'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  TextFormField(
                    controller: _userAdminController.emailDoctorController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  TextFormField(
                    controller: _userAdminController.nameDoctorController,
                    decoration: const InputDecoration(labelText: 'name'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  TextFormField(
                    controller: _userAdminController.lastnameDoctorController,
                    decoration: const InputDecoration(labelText: 'lastname'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  TextFormField(
                    controller: _userAdminController.passwordDoctorController,
                    decoration: const InputDecoration(labelText: 'password'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final success = await _userAdminController.signUp();

                      if (success) {
                        // Limpiar campos manualmente
                        _userAdminController.usernameDoctorController.clear();
                        _userAdminController.emailDoctorController.clear();
                        _userAdminController.nameDoctorController.clear();
                        _userAdminController.lastnameDoctorController.clear();
                        _userAdminController.passwordDoctorController.clear();

                        // Notificar éxito
                        Get.snackbar(
                          'Éxito',
                          'Doctor registrado correctamente',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );

                        // Actualizar lista de doctores
                        _doctorListController.fetchDoctors();
                      } else {
                        // Error ya se muestra desde el controller (puedes mejorar aquí si quieres)
                      }
                    },
                    child: const Text(
                      'Registrar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            const Divider(),

            // Lista de doctores
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
                physics: NeverScrollableScrollPhysics(),
                itemCount: _doctorListController.doctorList.length,
                itemBuilder: (context, index) {
                  final doctor = _doctorListController.doctorList[index];
                  return DoctorCard(doctor: doctor);
                },
              );
            }),
            /* Column(
              children: _doctors
                  .map((doc) => DoctorCard(
                        name: doc['name'] ?? '',
                        username: doc['username'] ?? '',
                        email: doc['email'] ?? '',
                        specialty: doc['specialty'] ?? '',
                      ))
                  .toList(),
            ),*/
          ],
        ),
      ),
    );
  }
}
