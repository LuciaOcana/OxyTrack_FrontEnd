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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión del personal médico'),
        backgroundColor: const Color(0xFF0096C7),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans', // tu fuente
          fontWeight: FontWeight.bold, // negrita
          fontSize: 20, // tamaño a tu gusto
          color: Colors.white, // color del texto
        ), // ✅ Esto centra el título
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Registrar Doctor',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF0097C7),
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Campos de formulario
                  TextFormField(
                    controller: _userAdminController.usernameDoctorController,
                    decoration: _inputDecoration('Username'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _userAdminController.emailDoctorController,
                    decoration: _inputDecoration('Email'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _userAdminController.nameDoctorController,
                    decoration: _inputDecoration('Nombre'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _userAdminController.lastnameDoctorController,
                    decoration: _inputDecoration('Apellido'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 20),

                  // Selector múltiple de pacientes
                  Obx(() {
                    return InkWell(
                      onTap: () async {
                        final List<String>?
                        results = await showDialog<List<String>>(
                          context: context,
                          builder: (context) {
                            List<String> tempSelected = List.from(
                              _userAdminController.selectedPatients,
                            );
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text('Seleccionar pacientes'),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: ListView(
                                      children:
                                          _userAdminController.patientsList.map(
                                            (patient) {
                                              return CheckboxListTile(
                                                title: Text(patient),
                                                value: tempSelected.contains(
                                                  patient,
                                                ),
                                                onChanged: (bool? selected) {
                                                  setState(() {
                                                    if (selected == true) {
                                                      tempSelected.add(patient);
                                                    } else {
                                                      tempSelected.remove(
                                                        patient,
                                                      );
                                                    }
                                                  });
                                                },
                                              );
                                            },
                                          ).toList(),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, null),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pop(
                                            context,
                                            tempSelected,
                                          ),
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );

                        if (results != null) {
                          _userAdminController.selectedPatients.value = results;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _userAdminController.selectedPatients.isEmpty
                              ? 'Seleccionar pacientes'
                              : _userAdminController.selectedPatients.join(
                                ', ',
                              ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _userAdminController.passwordDoctorController,
                    decoration: _inputDecoration('Contraseña'),
                    obscureText: true,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF0096C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await _userAdminController.signUp();
                        if (success) {
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

                          _doctorListController.fetchDoctors();
                          _userAdminController.loadPatients();
                        }
                      }
                    },
                    child: const Text(
                      'Registrar',
                      style: TextStyle(
                        fontSize: 19,
                        color: Color(0xFFCAF0F8),
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          //title: const Text("Confirmar"),
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
                backgroundColor: const Color(0xFFFFE4E1),
              ),
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
                backgroundColor: const Color(0xFFB31B1B),
              ),
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
