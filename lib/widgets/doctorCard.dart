// ======================================================
// doctorCard.dart
// Tarjeta para mostrar información de un doctor
// Permite editar datos y asignar pacientes
// ======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import '../models/userDoctor.dart';
import '../controllers/userAdminController.dart';

class DoctorCard extends StatelessWidget {
  /// Doctor que se mostrará en la tarjeta
  final UserDoctorModel doctor;

  /// Callback opcional al guardar cambios
  final VoidCallback? onEdit;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;


    // Colores dinámicos según el tema
    final nameColor = isLight ? const Color(0xFF023E8A) : const Color.fromARGB(255, 119, 220, 237);
    final userAndEmailColor = isLight ? Colors.grey.shade500 : const Color.fromARGB(255, 208, 241, 247);
    final buttonColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final textColor = isLight ? Colors.black87 : Colors.white;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF0096C7), width: 2),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre completo
            Text(
              '${doctor.name} ${doctor.lastname}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: nameColor),
            ),
            const SizedBox(height: 8),
            // Username
            Text('Nombre de usuario: ${doctor.username}', style: TextStyle(fontSize: 16, color: userAndEmailColor)),
            const SizedBox(height: 4),
            // Email
            Text('Correo electrónico: ${doctor.email}', style: TextStyle(fontSize: 16, color: userAndEmailColor)),
            const SizedBox(height: 12),
            // Botón Editar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(context, doctor.username, textColor),
                  icon: const Icon(Icons.edit, color: Color(0xFFCAF0F8)),
                  label: const Text('Editar', style: TextStyle(color: Color(0xFFCAF0F8))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra un diálogo para editar los datos del doctor
  void _showEditDialog(BuildContext context, String usernameDoctorCard, Color textColor) {
    final UserAdminController _userAdminController = UserAdminController();

final RxBool _obscurePasswordDoctorCard = true.obs;

    // Inicializar controladores con los datos actuales del doctor
    _userAdminController.usernameDoctorControllerEdit.text = doctor.username;
    _userAdminController.emailDoctorControllerEdit.text = doctor.email;
    _userAdminController.nameDoctorControllerEdit.text = doctor.name;
    _userAdminController.lastnameDoctorControllerEdit.text = doctor.lastname;
    _userAdminController.passwordDoctorControllerEdit.text = '';
    _userAdminController.selectedPatientsEdit.assignAll(doctor.patients ?? []);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Editar médico', style: TextStyle(color: textColor), textAlign: TextAlign.center),
          content: SizedBox(
            width: 500,
            height: 400,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Campos de texto
                      TextField(controller: _userAdminController.usernameDoctorControllerEdit, decoration: const InputDecoration(labelText: 'Nombre de usuario')),
                      const SizedBox(height: 8),
                      TextField(controller: _userAdminController.emailDoctorControllerEdit, decoration: const InputDecoration(labelText: 'Correo electrónico')),
                      const SizedBox(height: 8),
                      TextField(controller: _userAdminController.nameDoctorControllerEdit, decoration: const InputDecoration(labelText: 'Nombre')),
                      const SizedBox(height: 8),
                      TextField(controller: _userAdminController.lastnameDoctorControllerEdit, decoration: const InputDecoration(labelText: 'Apellido')),
                      const SizedBox(height: 12),

                      // Selector de pacientes
                      Obx(() {
                        final isLight = Theme.of(context).brightness == Brightness.light;
                        final textColor = isLight ? Colors.black87 : Colors.white;
                        final bgColor = isLight ? Colors.grey[100] : Colors.grey[800];
                        final shadowColor = isLight ? Colors.black12 : Colors.black54;

                        return InkWell(
                          onTap: () async {
                            await _userAdminController.loadPatients();
                            final List<String>? results = await showDialog<List<String>>(
                              context: context,
                              builder: (context) {
                                List<String> tempSelected = List.from(_userAdminController.selectedPatientsEdit);
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      title: Text('Seleccionar pacientes', style: TextStyle(color: textColor)),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: ListView(
                                          children: _userAdminController.patientsList.map((patient) {
                                            return CheckboxListTile(
                                              title: Text(patient),
                                              value: tempSelected.contains(patient),
                                              onChanged: (bool? selected) {
                                                setState(() {
                                                  if (selected == true) tempSelected.add(patient);
                                                  else tempSelected.remove(patient);
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context, null), child: Text('Cancelar', style: TextStyle(color: textColor))),
                                        ElevatedButton(onPressed: () => Navigator.pop(context, tempSelected), child: Text('Aceptar', style: TextStyle(color: textColor))),
                                      ],
                                    );
                                  },
                                );
                              },
                            );

                            if (results != null) _userAdminController.selectedPatientsEdit.assignAll(results);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: shadowColor!, blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Text(
                              _userAdminController.selectedPatientsEdit.isEmpty
                                  ? 'Seleccionar pacientes'
                                  : _userAdminController.selectedPatientsEdit.join(', '),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),

                      // Contraseña
                      Obx(() => TextField(
      controller: _userAdminController.passwordDoctorControllerEdit,
      obscureText: _obscurePasswordDoctorCard.value,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePasswordDoctorCard.value ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => _obscurePasswordDoctorCard.value = !_obscurePasswordDoctorCard.value,
        ),
      ),
    )),

                    ],
                  ),
                ),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar', style: TextStyle(color: textColor))),
            ElevatedButton(
              onPressed: () async {
                final originalUsername = doctor.username;
                final updatedDoctor = <String, dynamic>{};

                // Actualizar campos si cambiaron
                final username = _userAdminController.usernameDoctorControllerEdit.text.trim();
                if (username.isNotEmpty && username != doctor.username) updatedDoctor["username"] = username;

                final email = _userAdminController.emailDoctorControllerEdit.text.trim();
                if (email.isNotEmpty && email != doctor.email) {
                  if (!GetUtils.isEmail(email)) {
                    Get.snackbar('Error', 'Correo electrónico no válido', snackPosition: SnackPosition.BOTTOM);
                    return;
                  }
                  updatedDoctor["email"] = email;
                }

                final name = _userAdminController.nameDoctorControllerEdit.text.trim();
                if (name.isNotEmpty && name != doctor.name) updatedDoctor["name"] = name;

                final lastname = _userAdminController.lastnameDoctorControllerEdit.text.trim();
                if (lastname.isNotEmpty && lastname != doctor.lastname) updatedDoctor["lastname"] = lastname;

                final password = _userAdminController.passwordDoctorControllerEdit.text.trim();
                final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
                if (password.isNotEmpty) {
                  if (!regex.hasMatch(password)) {
                    Get.snackbar('Error', 'La contraseña debe tener al menos 7 caracteres, una mayúscula, una minúscula, un número y un carácter especial', snackPosition: SnackPosition.BOTTOM);
                    return;
                  }
                  updatedDoctor["password"] = password;
                }

                // Actualizar pacientes si cambiaron
                if (_userAdminController.selectedPatientsEdit.isNotEmpty &&
                    !listEquals(_userAdminController.selectedPatientsEdit, doctor.patients ?? [])) {
                  updatedDoctor["patients"] = _userAdminController.selectedPatientsEdit.toList();
                }

                print("DOCTOR $updatedDoctor");

                final success = await _userAdminController.updateDoctor(originalUsername, updatedDoctor);
                if (success) {
                  Navigator.of(context).pop();
                  _userAdminController.loadPatients();
                  if (onEdit != null) onEdit!();
                }
              },
              child: Text('Guardar', style: TextStyle(color: textColor)),
            ),
          ],
        );
      },
    );
  }
}
