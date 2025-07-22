import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/services/userDoctorServices.dart';
import 'package:oxytrack_frontend/services/userServices.dart';
import 'package:oxytrack_frontend/models/userDoctor.dart';

class UserDoctorController extends GetxController {
  final UserDoctorServices userDoctorServices= Get.put(UserDoctorServices());

    // Variables del Log In de doctor
  final TextEditingController usernameLogInDoctorController =
      TextEditingController();
  final TextEditingController passwordLogInDoctorController =
      TextEditingController();

  /*// Variables del registro de doctor
  final TextEditingController usernameDoctorController = TextEditingController();
  final TextEditingController emailDoctorController = TextEditingController();
  final TextEditingController nameDoctorController = TextEditingController();
  final TextEditingController lastnameDoctorController = TextEditingController();
  final TextEditingController passwordDoctorController = TextEditingController();*/

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void logIn() async {
    if (usernameLogInDoctorController.text.isEmpty || passwordLogInDoctorController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Campos vacíos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    print('🟢 Iniciando sesión desde UserController...');

    final logInDoctor = (
      username: usernameLogInDoctorController.text,
      password: passwordLogInDoctorController.text,
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final responseCode = await userDoctorServices.logInDoctor(logInDoctor);

      print('🔍 Respuesta del backend: $responseCode');

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
        Get.toNamed('/home');  //ESTO HAY QUE CAMBIARLO POR LA PAGINA PRINCIPAL DE DOCTOR
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


  // Registro de usuario

  /*void signUp() async {
    if (usernameDoctorController.text.isEmpty ||
        emailDoctorController.text.isEmpty ||
        nameDoctorController.text.isEmpty ||
        lastnameDoctorController.text.isEmpty ||
        passwordDoctorController.text.isEmpty) {
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
      final newDoctor = UserDoctorModel(
        username: usernameDoctorController.text.trim(),
        email: emailDoctorController.text.trim(),
        name: nameDoctorController.text.trim(),
        lastname: lastnameDoctorController.text.trim(),
        password: passwordDoctorController.text.trim(),
      );

      final response = await userDoctorServices.createDoctor(newDoctor);
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
    } catch (e) {
      errorMessage.value = 'Error al registrar usuario';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }*/
}
