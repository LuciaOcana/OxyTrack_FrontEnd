import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:oxytrack_frontend/controllers/userAdminController.dart';
import 'package:oxytrack_frontend/controllers/doctorListController.dart';
import 'package:oxytrack_frontend/services/userAdminServices.dart';

class AdminAddDoctorPageScreen extends StatefulWidget {
  const AdminAddDoctorPageScreen({super.key});

  @override
  State<AdminAddDoctorPageScreen> createState() =>
      _AdminAddDoctorPageScreenState();
}

class _AdminAddDoctorPageScreenState extends State<AdminAddDoctorPageScreen> {
  final _formKey = GlobalKey<FormState>();

  final UserAdminController _userAdminController = Get.put(
    UserAdminController(),
  );
  final DoctorListController _doctorListController = Get.put(
    DoctorListController(),
  );

 
  @override
  void initState() {
    super.initState();
    _userAdminController.loadPatients(); // Carga pacientes al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Doctores'),
        backgroundColor: Colors.lightBlueAccent,
        automaticallyImplyLeading: false,
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
        child: Form(
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
              const SizedBox(height: 16),

              // 🔹 Dropdown de pacientes usando Obx
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Seleccionar paciente",
                    border: OutlineInputBorder(),
                  ),
                  value:
                      _userAdminController.selectedPatients.isNotEmpty
                          ? _userAdminController.selectedPatients.first
                          : null,
                  items:
                      _userAdminController.patientsList
                          .map(
                            (patient) => DropdownMenuItem<String>(
                              value: patient,
                              child: Text(patient),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _userAdminController.selectedPatients.value = [value];
                    }
                  },
                );
              }),

              const SizedBox(height: 12),
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
                  if (_formKey.currentState!.validate()) {
                    final success = await _userAdminController.signUp();
                    if (success) {
                      // Limpiar campos
                      _userAdminController.usernameDoctorController.clear();
                      _userAdminController.emailDoctorController.clear();
                      _userAdminController.nameDoctorController.clear();
                      _userAdminController.lastnameDoctorController.clear();
                      _userAdminController.passwordDoctorController.clear();
                      _userAdminController.selectedPatients.clear();

                      Get.snackbar(
                        'Éxito',
                        'Doctor registrado correctamente',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );

                      // Refresca lista de doctores
                      _doctorListController.fetchDoctors();
                    }
                  }
                },
                child: const Text('Registrar', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

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
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _userAdminController.logout();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Cerrar sesión"),
            ),
          ],
        );
      },
    );
  }
}
