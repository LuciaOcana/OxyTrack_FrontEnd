import 'package:flutter/material.dart';
import 'package:mioxi_frontend/controllers/userDoctorController.dart';

class LogInDoctorScreen extends StatefulWidget {
  @override
  _LogInDoctorScreenState createState() => _LogInDoctorScreenState();
}

class _LogInDoctorScreenState extends State<LogInDoctorScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final UserDoctorController _userDoctorController = UserDoctorController();

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
        title: const Text('Inicio de sesión de doctor'),
        backgroundColor: appBarColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
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
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese su usuario' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userDoctorController.passwordLogInDoctorController,
                    decoration: _inputDecoration('Contraseña', isLight),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese su contraseña' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_loginFormKey.currentState!.validate()) {
                        _userDoctorController.logIn();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
