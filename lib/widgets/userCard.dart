// ======================================================
// userCard.dart
// Widget para mostrar la información de un usuario
// Incluye notificaciones y edición de medicación
// ======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../controllers/userController.dart';
import '../others/sessionManager.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onEdit;
  final RxBool hasNotification;

  const UserCard({
    Key? key,
    required this.user,
    required this.hasNotification,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    // Colores según tema
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
            // 🔹 Nombre con notificación
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: nameColor),
                  ),
                ),
                Obx(() => _notificationRow(textColor)),
              ],
            ),

            const SizedBox(height: 8),

            // 🔹 Username
            Text('Nombre de usuario: ${user.username}', style: TextStyle(fontSize: 16, color: userAndEmailColor)),
            const SizedBox(height: 4),

            // 🔹 Email
            Text('Correo electrónico: ${user.email}', style: TextStyle(fontSize: 16, color: userAndEmailColor)),
            const SizedBox(height: 12),

            // 🔹 Botón Editar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(context, textColor),
                  icon: const Icon(Icons.edit),
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

  // ------------------------------
  // 🔹 Fila de notificación reactiva
  // ------------------------------
  Widget _notificationRow(Color textColor) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasNotification.value ? Colors.green : Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        if (hasNotification.value)
          const Icon(Icons.notification_important, color: Colors.red),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.power_settings_new, size: 20),
          tooltip: 'Apagar notificación',
          onPressed: () => hasNotification.value = false,
        ),
      ],
    );
  }

  // ------------------------------
  // 🔹 Diálogo para editar medicación
  // ------------------------------
  void _showEditDialog(BuildContext context, Color textColor) {
    final UserController _userController = UserController();
    _userController.medicationControllerEdit.text = user.medication.join(", ");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Editar medicación usuario', style: TextStyle(color: textColor), textAlign: TextAlign.center),
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
                          helperText: 'Ingrese medicaciones separadas por comas',
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
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar', style: TextStyle(color: textColor))),
            ElevatedButton(
              onPressed: () async {
                await _saveMedication(context, _userController);
              },
              child: Text('Guardar', style: TextStyle(color: textColor)),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------
  // 🔹 Guardar cambios de medicación
  // ------------------------------
  Future<void> _saveMedication(BuildContext context, UserController _userController) async {
    final updatedFields = <String, dynamic>{};
    final medicationText = _userController.medicationControllerEdit.text.trim();

    if (medicationText.isNotEmpty &&
        !listEquals(medicationText.split(',').map((e) => e.trim()).toList(), user.medication)) {
      updatedFields["medication"] = medicationText.split(',').map((e) => e.trim()).toList();
    }

    final currentUsername = await SessionManager.getUsername("user") ?? user.username;
    await _userController.updateUserByDoctor(currentUsername, updatedFields);

    Navigator.of(context).pop();
    if (onEdit != null) onEdit!();
  }
}
