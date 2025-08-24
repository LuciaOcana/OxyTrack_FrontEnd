import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:oxytrack_frontend/models/userAdmin.dart';
import 'package:oxytrack_frontend/services/userAdminServices.dart';
import 'package:oxytrack_frontend/controllers/userAdminController.dart';
import 'package:oxytrack_frontend/screen/homePageScreen.dart';

class LogInAdminScreen extends StatefulWidget {
  @override
  _LogInAdminScreenState createState() => _LogInAdminScreenState();
}

class _LogInAdminScreenState extends State<LogInAdminScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserAdminServices _userAdminServices = UserAdminServices();
  final UserAdminController _userAdminController = UserAdminController();

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
    final altButtonBg = isLight ? const Color(0xFFCAF0F8) : const Color(0xFF001d3d);
    final altButtonText = isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final titleColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final textColor = isLight ? Colors.black87 : Colors.white;
    final dialogBg = isLight ? Colors.white : const Color(0xFF1E1E1E);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de sesión de administrador'),
        backgroundColor: appBarColor,
        centerTitle: true,
        automaticallyImplyLeading: true, // ✅ Esto habilita la flecha
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 26,
                      color: titleColor,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Campo Usuario
                  TextFormField(
                    controller: _userAdminController.usernameAdminController,
                    decoration: _inputDecoration('Nombre de usuario', isLight),
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese su usuario' : null,
                  ),
                  const SizedBox(height: 16),

                  // Campo Contraseña
                  TextFormField(
                    controller: _userAdminController.passwordAdminController,
                    decoration: _inputDecoration('Contraseña', isLight),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese su contraseña' : null,
                  ),
                  const SizedBox(height: 24),

                  // Botón Login
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _userAdminController.logIn();
                        Navigator.of(context).pop();
                      }
                    },
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
