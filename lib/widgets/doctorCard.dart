import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/userDoctor.dart';
import '../controllers/userAdminController.dart';

class DoctorCard extends StatelessWidget {
  final UserDoctorModel doctor;
  final VoidCallback? onEdit;

  const DoctorCard({Key? key, required this.doctor, this.onEdit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFF0096C7), // Borde azul
          width: 2,
        ),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${doctor.name} ${doctor.lastname}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${doctor.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Username: ${doctor.username}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showEditDialog(context, doctor.username);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0096C7),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String usernameDoctorCard) {
    final UserAdminController _userAdminController = UserAdminController();

    // Inicializar los controladores con los datos del doctor seleccionado
    _userAdminController.usernameDoctorControllerEdit.text = doctor.username;
    _userAdminController.emailDoctorControllerEdit.text = doctor.email;
    _userAdminController.nameDoctorControllerEdit.text = doctor.name;
    _userAdminController.lastnameDoctorControllerEdit.text = doctor.lastname;
    _userAdminController.passwordDoctorControllerEdit.text =
        ""; // No mostramos la real
    _userAdminController.selectedPatientsEdit.assignAll(doctor.patients ?? []);

    showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text('Editar Personal', textAlign: TextAlign.center), // 👈 título centrado
      content: SizedBox(
        width: 500, // ancho total del popup
        height: 400, // alto total
        child: Center( // 👈 centramos el contenido
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350), // 👈 límite de ancho del formulario
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _userAdminController.usernameDoctorControllerEdit,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _userAdminController.emailDoctorControllerEdit,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _userAdminController.nameDoctorControllerEdit,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: _userAdminController.lastnameDoctorControllerEdit,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                  ),
                  const SizedBox(height: 12),

                  Obx(() {
                    return InkWell(
                      onTap: () async {
                        //await _userAdminController.loadPatients(); // 🔹 asegúrate de cargar la lista
// 🔹 Cargar la lista de pacientes antes de mostrar el diálogo
  await _userAdminController.loadPatients();
                        final List<String>?
                        results = await showDialog<List<String>>(
                          context: context,
                          builder: (context) {
                            List<String> tempSelected = List.from(
                              _userAdminController.selectedPatientsEdit,
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

                  // 🔹 Selector múltiple de pacientes
                  /*Obx(() {
                    return ListTile(
                      title: const Text("Pacientes asignados"),
                      subtitle: Text(
                        _userAdminController.selectedPatientsEdit.isEmpty
                            ? "Ninguno"
                            : _userAdminController.selectedPatientsEdit.join(", "),
                      ),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: () async {
                        final List<String>? results = await showDialog<List<String>>(
                          context: context,
                          builder: (context) {
                            List<String> tempSelected = List.from(
                              _userAdminController.selectedPatientsEdit,
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
                                      shrinkWrap: true,
                                      children: _userAdminController.patientsList.map((patient) {
                                        return CheckboxListTile(
                                          title: Text(patient),
                                          value: tempSelected.contains(patient),
                                          onChanged: (bool? selected) {
                                            setState(() {
                                              if (selected == true) {
                                                tempSelected.add(patient);
                                              } else {
                                                tempSelected.remove(patient);
                                              }
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, null),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, tempSelected),
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );

                        if (results != null) {
                          _userAdminController.selectedPatientsEdit.assignAll(results);
                        }
                      },
                    );
                  }),*/

                  const SizedBox(height: 12),

                  TextField(
                    controller: _userAdminController.passwordDoctorControllerEdit,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center, // 👈 centra los botones
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final originalUsername = doctor.username;

            await _userAdminController.updateDoctor(originalUsername, doctor);

            Navigator.of(context).pop();
            if (onEdit != null) onEdit!();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  },
);

}
}