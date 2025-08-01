import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:oxytrack_frontend/models/userDoctor.dart'; // Importa el modelo de usuario
import 'package:oxytrack_frontend/services/userDoctorServices.dart'; // Importa los servicios
import 'package:oxytrack_frontend/screen/homePageScreen.dart';
import 'package:oxytrack_frontend/controllers/userDoctorController.dart';


class LogInDoctorScreen extends StatefulWidget {
  @override
  _LogInDoctorScreenState createState() => _LogInDoctorScreenState();
}

class _LogInDoctorScreenState extends State<LogInDoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos del formulario logIn
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   // Controladores para registro
  final TextEditingController _usernameControllerD = TextEditingController();
  final TextEditingController _emailControllerD = TextEditingController();
  final TextEditingController _nameControllerD = TextEditingController();
  final TextEditingController _lastnameControllerD = TextEditingController();
  final TextEditingController _passwordControllerD = TextEditingController();

  final UserDoctorServices _userDoctorServices = UserDoctorServices();
  final UserDoctorController _userDoctorController = UserDoctorController();

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
              controller: _userDoctorController.usernameLogInDoctorController,
              decoration: InputDecoration(labelText: 'Usuario')),
            TextField(
              controller: _userDoctorController.passwordLogInDoctorController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _userDoctorController.logIn();
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
