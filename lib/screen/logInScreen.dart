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
    final tempPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 600, // <- aquí defines el ancho que tú quieras
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Registro de usuario',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userController.usernameController,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Username',
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Campo requerido' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _userController.emailController,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Email',
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Campo requerido';
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value))
                              return 'Formato de email inválido';
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _userController.nameController,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Nombre',
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Campo requerido' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _userController.lastnameController,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Apellidos',
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Campo requerido' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _userController.birthDateController,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Fecha de nacimiento',
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  TextSpan(
                                    text: ' (dd/mm/aaaa)', // Aquí va el formato
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),

                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Campo requerido' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _userController.heightController,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Altura',
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Campo requerido' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _userController.weightController,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Peso',
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Campo requerido' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: tempPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Contraseña',
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Campo requerido' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Confirmar contraseña',
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Campo requerido';
                            if (value != tempPasswordController.text)
                              return 'Las contraseñas no coinciden';
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                //const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _userController.passwordController.text =
                              tempPasswordController.text;
                          _userController.signUp();
                          _userController.usernameController.clear();
                          _userController.emailController.clear();
                          _userController.nameController.clear();
                          _userController.lastnameController.clear();
                          _userController.birthDateController.clear();
                          _userController.heightController.clear();
                          _userController.weightController.clear();
                          tempPasswordController.clear();
                          confirmPasswordController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Registrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
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
