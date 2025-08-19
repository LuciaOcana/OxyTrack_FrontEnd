import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/userDoctorController.dart';

class HomeDoctorEditDoctorPageScreen extends StatefulWidget {
  const HomeDoctorEditDoctorPageScreen({super.key});

  @override
  State<HomeDoctorEditDoctorPageScreen> createState() =>
      _HomeDoctorEditDoctorPageScreenState();
}

class _HomeDoctorEditDoctorPageScreenState
    extends State<HomeDoctorEditDoctorPageScreen> {
  final UserDoctorController _userDoctorController = UserDoctorController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Perfil del Doctor"),
        backgroundColor: const Color(0xFF0096C7),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 🔹 Avatar + Bienvenida
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              "Bienvenido",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              _userDoctorController.usernameLogInDoctorController.text,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 40),

            // 🔹 Botones de opciones
            _actionButton(
              icon: Icons.lock_reset,
              text: "Cambiar contraseña",
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),
            const SizedBox(height: 16),
            _actionButton(
              icon: Icons.edit_note,
              text: "Solicitud de cambio de perfil",
              onTap: () {
                _showEmailDialog(
                  context,
                  "Solicitud de cambio de perfil",
                  "Describe los cambios que deseas realizar en tu perfil:",
                );
              },
            ),
            const SizedBox(height: 16),
            _actionButton(
              icon: Icons.people,
              text: "Solicitud de cambio de paciente",
              onTap: () {
                _showEmailDialog(
                  context,
                  "Solicitud de cambio de paciente",
                  "Describe los detalles de la solicitud de cambio de paciente:",
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Widget para botones elegantes
  Widget _actionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: const Color(0xFF0096C7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
      ),
      icon: Icon(icon, size: 26, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      onPressed: onTap,
    );
  }

  /// 🔹 Dialog para cambiar contraseña
  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController passCtrl = TextEditingController();
    final TextEditingController confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Cambiar contraseña"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: "Nueva contraseña"),
              obscureText: true,
            ),
            TextField(
              controller: confirmCtrl,
              decoration:
                  const InputDecoration(labelText: "Confirmar contraseña"),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              
                // 🔹 Lógica para cambiar contraseña
                _userDoctorController.passwordChange(passCtrl.text, confirmCtrl.text);
                Navigator.pop(context);
                
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Dialog genérico para redactar email
  void _showEmailDialog(BuildContext context, String title, String hint) {
    final TextEditingController msgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: TextField(
          controller: msgCtrl,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (msgCtrl.text.isNotEmpty) {
                // 🔹 Aquí enviarías el mail al admin
                Navigator.pop(context);
                Get.snackbar("Enviado",
                    "Tu solicitud ha sido enviada al administrador",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue.shade400,
                    colorText: Colors.white);
              }
            },
            child: const Text("Enviar"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Dialog de cierre de sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text("¿Estás seguro de que quieres cerrar sesión?",
            style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB31B1B),
            ),
            onPressed: () {
              // 🔹 Aquí cerrar sesión
              Navigator.pop(context);
            },
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }
}
