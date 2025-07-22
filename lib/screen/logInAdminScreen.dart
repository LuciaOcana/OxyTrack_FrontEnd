import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:oxytrack_frontend/models/userAdmin.dart'; // Importa el modelo de usuario
import 'package:oxytrack_frontend/services/userAdminServices.dart'; // Importa los servicios
import 'package:oxytrack_frontend/controllers/userAdminController.dart'; // Importa los servicios
import 'package:oxytrack_frontend/screen/homePageScreen.dart';

class LogInAdminScreen extends StatefulWidget {
  @override
  _LogInAdminScreenState createState() => _LogInAdminScreenState();
}

class _LogInAdminScreenState extends State<LogInAdminScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos del formulario logIn
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserAdminServices _userAdminServices = UserAdminServices();
  final UserAdminController _userAdminController = UserAdminController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userAdminController.usernameAdminController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _userAdminController.passwordAdminController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _userAdminController.logIn();
                Navigator.of(context).pop();
              },
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
