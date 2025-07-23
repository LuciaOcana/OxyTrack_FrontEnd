import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/services/userAdminServices.dart';
import 'package:oxytrack_frontend/models/user.dart';
import 'package:oxytrack_frontend/models/userDoctor.dart';
import 'package:oxytrack_frontend/services/userDoctorServices.dart';

class UserAdminController extends GetxController {
  final UserAdminServices userAdminServices = Get.put(UserAdminServices());
    final UserDoctorServices userDoctorServices= Get.put(UserDoctorServices());


// Variables del Log In de usuario
  final TextEditingController usernameAdminController = TextEditingController();
  final TextEditingController passwordAdminController = TextEditingController();


    // Variables del registro de doctor
  final TextEditingController usernameDoctorController = TextEditingController();
  final TextEditingController emailDoctorController = TextEditingController();
  final TextEditingController nameDoctorController = TextEditingController();
  final TextEditingController lastnameDoctorController = TextEditingController();
  final TextEditingController passwordDoctorController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void logIn() async {
    if (usernameAdminController.text.isEmpty || passwordAdminController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Campos vacíos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    print('🟢 Iniciando sesión desde UserController...');

    final logInAdmin = (
      username: usernameAdminController.text,
      password: passwordAdminController.text,
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final responseCode = await userAdminServices.logIn(logInAdmin);

      print('🔍 Respuesta del backend: $responseCode');

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
        Get.toNamed('/adminPage');
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

  void signUp() async {
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

      final response = await userAdminServices.createDoctor(newDoctor);
      print('----------------- ${response}');

      if (response != null && response == 201) {
        Get.snackbar('Éxito', 'Doctor creado exitosamente');
      } else {
        errorMessage.value =
            'Error: Este E-Mail o nombre de doctor ya están en uso';
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
  }

  }