import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oxytrack_frontend/services/irServices.dart'; // Importa los servicios

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final RxString name = ''.obs;
  final RxString email = ''.obs;

  @override
  void initState() {
    super.initState();
    loadUserData();
    IrService().connect(); // 🔌 WebSocket
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('user_name') ?? 'Usuario';
    email.value = prefs.getString('user_email') ?? 'correo@ejemplo.com';
  }

  Future<void> saveUserData(String newName, String newEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);
    await prefs.setString('user_email', newEmail);
    name.value = newName;
    email.value = newEmail;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    await prefs.remove('user_name');
    await prefs.remove('user_email');

    Get.offAllNamed('/selectorMode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: const Color(0xFF0096C7),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "👤", // Emoticono bonito en vez del círculo
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              Obx(() => Text(
                    name.value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  )),
              const SizedBox(height: 8),
              Obx(() => Text(
                    email.value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'OpenSans',
                    ),
                  )),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => _EditProfileDialog(
                      currentName: name.value,
                      currentEmail: email.value,
                      onSave: saveUserData,
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0096C7),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final Function(String, String) onSave;

  const _EditProfileDialog({
    required this.currentName,
    required this.currentEmail,
    required this.onSave,
  });

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Editar Perfil',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          color: Color(0xFF0096C7),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(nameController.text, emailController.text);
            Get.back();
            Get.snackbar(
              'Perfil actualizado',
              'Tu información ha sido guardada',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0096C7),
            foregroundColor: Colors.white,
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
