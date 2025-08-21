import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../controllers/userController.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onEdit;
  final bool hasNotification; // 🔹 Nueva propiedad

  const UserCard({
    Key? key,
    required this.user,
    this.onEdit,
    this.hasNotification = false, // 🔹 Por defecto false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFF0096C7),
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
            // 🔹 Nombre con notificación
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023E8A),
                    ),
                  ),
                ),
                if (hasNotification)
                  const Icon(
                    Icons.notification_important,
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // 🔹 Username
            Text(
              'Username: ${user.username}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),

            // 🔹 Email
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 12),

            // 🔹 Botón Editar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showEditDialog(context);
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

  void _showEditDialog(BuildContext context) {
    final UserController _userController = UserController();

    _userController.medicationControllerEdit.text =
        user.medication.join(", ");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Editar medicació del usuario',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: 500,
            height: 350,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller:
                            _userController.medicationControllerEdit,
                        decoration: const InputDecoration(
                          labelText:
                              'Medicacion (separe las diferentes medicaciones con una coma ",")',
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final dialogLoading = ValueNotifier(false);
                dialogLoading.value = true;

                final updatedFields = {
                  "username": user.username ?? "",
                  "email": user.email ?? "",
                  "name": user.name ?? "",
                  "lastname": user.lastname ?? "",
                  "birthDate": user.birthDate ?? "",
                  "age": user.age ?? "",
                  "weight": user.weight ?? "",
                  "height": user.height ?? "",
                  "medication": _userController.medicationControllerEdit.text
                          .trim()
                          .isNotEmpty
                      ? _userController.medicationControllerEdit.text
                          .split(",")
                          .map((e) => e.trim())
                          .toList()
                      : user.medication,
                  "doctor": user.doctor ?? "",
                  "password": user.password ?? ""
                };

                final success = await _userController.updateUserByDoctor(
                    user.username, updatedFields);

                dialogLoading.value = false;
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
