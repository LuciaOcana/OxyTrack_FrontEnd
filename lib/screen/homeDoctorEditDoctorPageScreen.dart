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
            icon: const Icon(Icons.logout, 
              color: Color(0xFFe2fdff),),
            
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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Cambiar contraseña"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _userDoctorController.passwordPasswLostControllerDoctor,
              decoration: const InputDecoration(labelText: "Nueva contraseña"),
              obscureText: true,
            ),
            TextField(
              controller: _userDoctorController.confirmPasswordControllerDoctor,
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
                _userDoctorController.changeDoctorPassword();
                Navigator.pop(context);
                
            },
            child: const Text("Guardar"),
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
