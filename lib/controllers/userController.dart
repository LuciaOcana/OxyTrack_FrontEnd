import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:oxytrack_frontend/services/userServices.dart';
import 'package:oxytrack_frontend/models/user.dart';

class UserController extends GetxController {
  final UserServices userService = Get.put(UserServices());

// Variables del Log In de usuario
  final TextEditingController usernameLogInController = TextEditingController();
  final TextEditingController passwordLogInController = TextEditingController();

  
  // Variables del registro de usuario
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController birthDateController =
      TextEditingController(); // en formato yyyy-MM-dd
  final TextEditingController ageController =
      TextEditingController(); // en formato yyyy-MM-dd
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

 
  void logIn() async {
    if (usernameLogInController.text.isEmpty || passwordLogInController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Campos vacíos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    print('🟢 Iniciando sesión desde UserController...');

    final logIn = (
      username: usernameLogInController.text,
      password: passwordLogInController.text,
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final responseCode = await userService.logIn(logIn);

      print('🔍 Respuesta del backend: $responseCode');

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
        Get.toNamed('/homeUser');
      } else if (responseCode == 300) {
        errorMessage.value = 'Usuario deshabilitado'.tr;
        Get.snackbar('Advertencia', errorMessage.value);
      } else {
        errorMessage.value = 'Usuario o contraseña incorrectos'.tr;
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error: No se pudo conectar con la API';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
// Funcion para guardar el usuario en el sharedPreference
Future<void> saveUserSession(UserModel user, String role) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('user_name', user.name);
  prefs.setString('user_email', user.email);
  prefs.setString('user_role', 'user'); // 'user', 'admin', 'doctor'
}

  // Registro de usuario

  void signUp() async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        birthDateController.text.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty) {
      errorMessage.value = 'Campos vacíos';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    /* // Validación de formato de correo electrónico
    if (!GetUtils.isEmail(emailController.text)) {
      errorMessage.value = 'Correo electrónico no válido';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Validación de contraseña segura
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    if (!regex.hasMatch(passwordController.text)) {
      errorMessage.value =
          'La contraseña debe tener al menos 7 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }*/

    isLoading.value = true;

    try {
      final newUser = UserModel(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        lastname: lastnameController.text.trim(),
        birthDate: birthDateController.text.trim(), // formato yyyy-MM-dd
        age: "",
        height: heightController.text.trim(),
        weight: weightController.text.trim(),
        medication: [],
        doctor: "",
        password: passwordController.text.trim(),
      );

      final response = await userService.createUser(newUser);
      print('----------------- ${response}');

      if (response != null && response == 201) {
        Get.snackbar('Éxito', 'Usuario creado exitosamente');
        Get.toNamed('/login');
      } else {
        errorMessage.value =
            'Error: Este E-Mail o nombre de usuario ya están en uso';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } /*catch (e) {
      errorMessage.value = 'Error al registrar usuario';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    */ finally {
      isLoading.value = false;
    }
  }
}
