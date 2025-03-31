import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:oxytrack_frontend/models/user.dart';  // Importa el modelo de usuario
import 'package:oxytrack_frontend/services/userServices.dart';  // Importa los servicios
import 'package:oxytrack_frontend/screen/homePageScreen.dart';

class logInScreen extends StatefulWidget {
  @override
  _logInScreenState createState() => _logInScreenState();
}

class _logInScreenState extends State<logInScreen>{

  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos del formulario logIn
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controladores de los campos del formulario register
  final TextEditingController _usernameControllerR = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _passwordControllerR = TextEditingController();

  final UserServices _userServices = UserServices();

// Función para manejar el registro
  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Crear el modelo de usuario
      UserModel newUser = UserModel(
        username: _usernameController.text,
        email: _emailController.text,
        name: _nameController.text,
        lastname: _lastnameController.text,
        birthDate: _birthDateController.text,
        age: _ageController.text.isEmpty ? null : _ageController.text,
        height: _heightController.text,
        weight: _weightController.text,
        medication: _medicationController.text.isEmpty
            ? []
            : _medicationController.text.split(','),
        password: _passwordController.text,
      );

      // Llamar al servicio para crear el usuario
      int statusCode = await _userServices.createUser(newUser);

      // Mostrar el resultado
      if (statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario creado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el usuario')),
        );
      }
    }
  }

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
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed('/home'),
              child: Text('Iniciar Sesión'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Registrarse'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => homePageScreen()),
                );
              },
              child: Text('Entrar como Invitado'),
            ),
          ],
        ),
      ),
    );
  }
}