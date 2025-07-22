import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:oxytrack_frontend/models/user.dart'; // Importa el modelo de usuario
import 'package:oxytrack_frontend/services/userServices.dart'; // Importa los servicios
import 'package:oxytrack_frontend/screen/homePageScreen.dart';
import 'package:oxytrack_frontend/controllers/userController.dart';

class logInScreen extends StatefulWidget {
  @override
  _logInScreenState createState() => _logInScreenState();
}

class _logInScreenState extends State<logInScreen> {
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
  final UserController _userController = UserController();

  // Función para manejar el registro
  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Crear el modelo de usuario
      UserModel newUser = UserModel(
        username: _usernameControllerR.text,
        email: _emailController.text,
        name: _nameController.text,
        lastname: _lastnameController.text,
        birthDate: _birthDateController.text,
        age: _ageController.text.isEmpty ? null : _ageController.text,
        height: _heightController.text,
        weight: _weightController.text,
        medication:
            _medicationController.text.isEmpty
                ? []
                : _medicationController.text.split(','),
        password: _passwordControllerR.text,
      );

      // Llamar al servicio para crear el usuario
      int statusCode = await _userServices.createUser(newUser);

      // Mostrar el resultado
      if (statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Usuario creado exitosamente')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al crear el usuario')));
      }
    }
  }

  // Función para mostrar el popup de registro
  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text('Registro de Usuario'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _userController.usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator:
                      (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _userController.emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator:
                      (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _userController.nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  controller: _userController.lastnameController,
                  decoration: InputDecoration(labelText: 'Apellidos'),
                ),
                TextFormField(
                  controller: _userController.birthDateController,
                  decoration: InputDecoration(labelText: 'Fecha de nacimiento'),
                ),
                TextFormField(
                  controller: _userController.ageController,
                  decoration: InputDecoration(labelText: 'Edad'),
                ),
                TextFormField(
                  controller: _userController.heightController,
                  decoration: InputDecoration(labelText: 'Altura'),
                ),
                TextFormField(
                  controller: _userController.weightController,
                  decoration: InputDecoration(labelText: 'Peso'),
                ),
                TextFormField(
                  controller: _userController.medicationController,
                  decoration: InputDecoration(
                    labelText: 'Medicación (opcional)',
                  ),
                ),
                TextFormField(
                  controller: _userController.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  validator:
                      (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _userController.signUp();
                //_register(); // Registra y si es exitoso, puedes cerrar el popup
                Navigator.of(context).pop();
              },
              child: Text('Registrar'),
            ),
          ],
        );
      },
    );
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
              controller: _userController.usernameLogInController,
              decoration: InputDecoration(labelText: 'Usuario')),
            TextField(
              controller: _userController.passwordLogInController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _userController.logIn();
                Navigator.of(context).pop();
              },
              child: Text('Iniciar Sesión'),
            ),
            TextButton(
              onPressed:
                  _showRegisterDialog, // Llama a la función para abrir el popup
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
