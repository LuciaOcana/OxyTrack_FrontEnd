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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        backgroundColor: const Color(0xFF0096C7),
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
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 26,
                      color: Color(0xFF0096C7),
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Campo Usuario
                  TextFormField(
                    controller: _userAdminController.usernameAdminController,
                    decoration: _inputDecoration('Usuario'),
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese su usuario' : null,
                  ),
                  const SizedBox(height: 16),

                  // Campo Contraseña
                  TextFormField(
                    controller: _userAdminController.passwordAdminController,
                    decoration: _inputDecoration('Contraseña'),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese su contraseña' : null,
                  ),
                  const SizedBox(height: 24),

                  // Botón Login
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF0096C7),
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
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCAF0F8),
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Opción de contraseña olvidada
                  TextButton(
                    onPressed: () {
                      // Aquí podrías agregar función de recuperación de contraseña
                    },
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                      ),
                      textAlign: TextAlign.center,
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
