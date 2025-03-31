import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/services/userServices.dart';


class UserController extends GetxController {
  final UserServices userService = Get.put(UserServices());
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  void logIn() async {
    // Validación de campos
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Campos vacíos',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    print('----- EL LOGIN FUNCIONA -----');

    final logIn = (
      username: usernameController.text,
      password: passwordController.text,
    );

    try {
      // Llamada al servicio para iniciar sesión
      final responseData = await userService.logIn(logIn);

      print('el response data es:${responseData}');

      if (responseData == 200) {

        print('Inicio de sesión exitoso.');
        // Manejo de respuesta exitosa
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
        Get.toNamed('/home');
      } else {
        print('Error de datos.');
      }
    } catch (e) {
print('Inicio de sesión erroneo.');    }
  }

  }
