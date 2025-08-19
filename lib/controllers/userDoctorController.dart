import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/services/userDoctorServices.dart';

class UserDoctorController extends GetxController {
  final UserDoctorServices _userDoctorServices= Get.put(UserDoctorServices());

    // Variables del Log In de doctor
  final TextEditingController usernameLogInDoctorController =
      TextEditingController();
  final TextEditingController passwordLogInDoctorController =
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

      print('🔍 Respuesta del backend: $responseCode');

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
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
void passwordChange(String newPass, String confirmNewPass) async {
  try {
    if (newPass == confirmNewPass && newPass.isNotEmpty) {
      final responseCode = await _userDoctorServices.newPassword(usernameLogInDoctorController.text, newPass); // Llamada al backend
            print('🔍 Respuesta del backend: $responseCode');

if (responseCode == 200) {
      Get.snackbar("Éxito", "Contraseña cambiada correctamente",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white);
    }} else {
      Get.snackbar("Error", "Las contraseñas no coinciden",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar("Error", "No se pudo cambiar la contraseña",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white);
    print("❌ Error en passwordChange: $e");
  }
}

}
