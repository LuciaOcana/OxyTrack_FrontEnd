import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:oxytrack_frontend/models/userDoctor.dart'; // Importa el modelo de usuario
import 'package:oxytrack_frontend/services/userDoctorServices.dart'; // Importa los servicios
import 'package:oxytrack_frontend/screen/homePageScreen.dart';

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

  // Función para manejar el registro
  /*void _register() async {
    if (_formKey.currentState!.validate()) {
      // Crear el modelo de usuario
      UserDoctorModel newDoctor = UserDoctorModel(
        username: _usernameControllerD.text,
        email: _emailControllerD.text,
        name: _nameControllerD.text,
        lastname: _lastnameControllerD.text,
        password: _passwordControllerD.text,
      );

      // Llamar al servicio para crear el usuario
      int statusCode = await _userDoctorServices.createDoctor(newDoctor);

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
  }*/

  // Función para mostrar el popup de registro
 /* void _showRegisterDialog() {
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
                  controller: _usernameControllerD,
                  decoration: InputDecoration(labelText: 'Usuario'),
                  validator:
                      (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _emailControllerD,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator:
                      (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: _nameControllerD,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  controller: _lastnameControllerD,
                  decoration: InputDecoration(labelText: 'Apellidos'),
                ),
                TextFormField(
                  controller: _passwordControllerD,
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
                //_register(); // Registra y si es exitoso, puedes cerrar el popup
                Navigator.of(context).pop();
              },
              child: Text('Registrar'),
            ),
          ],
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Usuario')),
            TextField(
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed('/home'),
              child: Text('Iniciar Sesión'),
            ),
            /*TextButton(
              onPressed:
                  _showRegisterDialog, // Llama a la función para abrir el popup
              child: Text('Registrarse'),
            ),*/
          ],
        ),
      ),
    );
  }
}
