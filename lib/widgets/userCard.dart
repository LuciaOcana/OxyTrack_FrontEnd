import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mioxi_frontend/others/sessionManager.dart';
import '../models/user.dart';
import '../controllers/userController.dart';
import 'package:flutter/foundation.dart'; // <-- necesario para listEquals

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onEdit;
  final RxBool hasNotification;

  const UserCard({
    Key? key,
    required this.user,
    this.onEdit,
    required this.hasNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final nameColor =
        isLight
            ? const Color(0xFF023E8A)
            : const Color.fromARGB(255, 119, 220, 237);
    final userAndEmailColor =
        isLight
            ? Colors.grey.shade500
            : const Color.fromARGB(255, 208, 241, 247);
    final buttonColor =
        isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
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
            // 🔹 Nombre con notificación
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: nameColor,
                    ),
                  ),
                ),
                Obx(
                  () => Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              hasNotification.value
                                  ? Colors.green
                                  : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (hasNotification.value)
                        const Icon(
                          Icons.notification_important,
                          color: Colors.red,
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.power_settings_new, size: 20),
                        tooltip: 'Apagar notificación',
                        onPressed: () {
                          hasNotification.value = false;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //const SizedBox(height: 8),

            // 🔹 Username
            Text(
              'Nombre de usuario: ${user.username}',
              style: TextStyle(fontSize: 16, color: userAndEmailColor),
            ),
            const SizedBox(height: 4),

            // 🔹 Email
            Text(
              'Correo electrónico: ${user.email}',
              style: TextStyle(fontSize: 16, color: userAndEmailColor),
            ),
            const SizedBox(height: 12),

            // 🔹 Botón Editar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showEditDialog(context, textColor);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Editar',
                    style: TextStyle(color: Color(0xFFCAF0F8)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
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

  void _showEditDialog(BuildContext context, Color textColor) {
    final UserController _userController = UserController();

    _userController.medicationControllerEdit.text = user.medication.join(", ");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Editar medicación usuario',
            style: TextStyle(color: textColor),
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
                        controller: _userController.medicationControllerEdit,
                        decoration: const InputDecoration(
                          labelText: 'Medicación',
                          helperText:
                              'Ingrese medicaciones separadas por comas', // nota debajo del campo
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
              child: Text('Cancelar', style: TextStyle(color: textColor)),
            ),
            ElevatedButton(
              onPressed: () async {
                final dialogLoading = ValueNotifier(false);
                dialogLoading.value = true;
                final updatedFields = <String, dynamic>{};

                // Tomamos el texto del TextField
                final medicationText =
                    _userController.medicationControllerEdit.text.trim();

                // Solo actualizamos si el campo no está vacío y es distinto del valor anterior
                if (medicationText.isNotEmpty &&
                    !listEquals(
                      medicationText.split(',').map((e) => e.trim()).toList(),
                      user.medication,
                    )) {
                  updatedFields["medication"] =
                      medicationText.split(',').map((e) => e.trim()).toList();
                }

                print("USUARIO:$updatedFields");
                final currentUsername = await SessionManager.getUsername("user") ?? user.username;
                final success = await _userController.updateUserByDoctor(
                  //user.username,
                  currentUsername,
                  updatedFields,
                );

                dialogLoading.value = false;
                Navigator.of(context).pop();
                if (onEdit != null) onEdit!();
              },
              child: Text('Guardar', style: TextStyle(color: textColor)),
            ),
          ],
        );
      },
    );
  }
}
