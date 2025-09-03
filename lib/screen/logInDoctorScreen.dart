import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mioxi_frontend/controllers/userDoctorController.dart';

class LogInDoctorScreen extends StatefulWidget {
  const LogInDoctorScreen({super.key});

  @override
  State<LogInDoctorScreen> createState() => _LogInDoctorScreenState();
}

class _LogInDoctorScreenState extends State<LogInDoctorScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final UserDoctorController _userDoctorController = UserDoctorController();
final RxBool _obscurePassword = true.obs; // 🔹 true = contraseña oculta al inicio


  InputDecoration _inputDecoration(String label, bool isLight) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isLight ? Colors.grey[100] : Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    // 🎨 Colores dinámicos
    final appBarColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final buttonColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final titleColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de sesión de doctor'),
        backgroundColor: appBarColor,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bienvenido doctor',
                    style: TextStyle(
                      fontSize: 26,
                      color: titleColor,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _userDoctorController.usernameLogInDoctorController,
                    decoration: _inputDecoration('Nombre de usuario', isLight),
                    validator: (value) => value!.isEmpty ? 'Ingrese su usuario' : null,
                  ),
                  const SizedBox(height: 16),
                  Obx(() => TextFormField(
  controller: _userDoctorController.passwordLogInDoctorController,
  obscureText: _obscurePassword.value, // depende del RxBool
  decoration: _inputDecoration('Contraseña', isLight).copyWith(
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword.value ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
      onPressed: () => _obscurePassword.value = !_obscurePassword.value,
    ),
  ),
  validator: (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
)),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_loginFormKey.currentState!.validate()) {
                        _userDoctorController.logIn();
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCAF0F8),
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
