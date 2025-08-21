import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/services/userDoctorServices.dart';
import 'package:oxytrack_frontend/others/sessionManager.dart';
import 'package:oxytrack_frontend/auth/tokenManager.dart';


class UserDoctorController extends GetxController {
  final UserDoctorServices _userDoctorServices= Get.put(UserDoctorServices());

  final tokenManager = TokenManager();

    // Variables del Log In de doctor
  final TextEditingController usernameLogInDoctorController =
      TextEditingController();
  final TextEditingController passwordLogInDoctorController =
      TextEditingController();


        final TextEditingController passwordPasswLostControllerDoctor =
      TextEditingController();
  final TextEditingController confirmPasswordControllerDoctor =
      TextEditingController();


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
      final responseCode = await _userDoctorServices.logInDoctor(logInDoctor);
      final token = await tokenManager.getToken(); // Recupera token guardado

      print('🔍 Respuesta del backend: $responseCode');

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
        await SessionManager.saveSession("doctor", token, usernameLogInDoctorController.text);

        Get.toNamed('/doctorPatientListPage');  //ESTO HAY QUE CAMBIARLO POR LA PAGINA PRINCIPAL DE DOCTOR
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

void changeDoctorPassword() async {
  try {
    final String? username = await SessionManager.getUsername("doctor");
    final newPassword = passwordPasswLostControllerDoctor.text.trim();
    final confirmPassword = confirmPasswordControllerDoctor.text.trim();

    print(username);

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Todos los campos son requeridos', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Las contraseñas no coinciden', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    if (!regex.hasMatch(newPassword)) {
      Get.snackbar('Error', 'La contraseña debe tener al menos 7 caracteres, una mayúscula, una minúscula, un número y un carácter especial', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final responseCode = await _userDoctorServices.updatePassword({
      "username": username,
      "newPassword": newPassword,
    });

    print('🔍 Respuesta del backend: $responseCode');

    if (responseCode == 200) {
      Get.snackbar("Éxito", "Contraseña cambiada correctamente", snackPosition: SnackPosition.BOTTOM);
      passwordPasswLostControllerDoctor.clear();
    } else {
      Get.snackbar("Error", "No se pudo cambiar la contraseña ($responseCode)", snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    Get.snackbar("Error", "Error inesperado: $e", snackPosition: SnackPosition.BOTTOM);
  }
}

}
