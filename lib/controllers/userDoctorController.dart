// ======================================================
// UserDoctorController: Controlador para doctores
// Maneja: Login, cambio de contraseña y Logout
// ======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mioxi_frontend/models/userDoctor.dart';
import 'package:mioxi_frontend/services/userDoctorServices.dart';
import 'package:mioxi_frontend/others/sessionManager.dart';
import 'package:mioxi_frontend/auth/tokenManager.dart';

class UserDoctorController extends GetxController {
  // ------------------------------
  // Servicios y dependencias
  // ------------------------------
  final UserDoctorServices _userDoctorServices = Get.put(UserDoctorServices());
  final tokenManager = TokenManager();

  // ------------------------------
  // Controladores de texto
  // ------------------------------
  final TextEditingController usernameLogInDoctorController = TextEditingController();
  final TextEditingController passwordLogInDoctorController = TextEditingController();

  final TextEditingController passwordPasswLostControllerDoctor = TextEditingController();
  final TextEditingController confirmPasswordControllerDoctor = TextEditingController();

  // ------------------------------
  // Variables reactivas
  // ------------------------------
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<UserDoctorModel> userDoctorModel = Rxn<UserDoctorModel>();
  UserDoctorModel? doctor;

  // ======================================================
  // Obtener doctor desde backend y guardarlo en el controlador
  // ======================================================
  Future<UserDoctorModel?> fetchUser(String role) async {
    try {
      final username = await SessionManager.getUsername(role);
      if (username != null) {
        doctor = await _userDoctorServices.getDoctor(username);
        userDoctorModel.value = doctor;
        return doctor;
      } else {
        print('No se encontró el username en sesión para el rol $role');
        return null;
      }
    } catch (e) {
      print('Error al obtener el usuario: $e');
      return null;
    }
  }

  // ======================================================
  // Login de doctor
  // ======================================================
  void logIn() async {
    if (usernameLogInDoctorController.text.isEmpty ||
        passwordLogInDoctorController.text.isEmpty) {
      Get.snackbar('Error', 'Campos vacíos', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final logInDoctor = (
      username: usernameLogInDoctorController.text,
      password: passwordLogInDoctorController.text,
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final responseCode = await _userDoctorServices.logInDoctor(logInDoctor);
      final token = await tokenManager.getToken();

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
        await SessionManager.saveSession("doctor", token, usernameLogInDoctorController.text);
        _userDoctorServices.connectWS(); // Conectar WebSocket
        Get.toNamed('/doctorPatientListPage'); // Página principal del doctor
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

  // ======================================================
  // Cambiar contraseña de doctor
  // ======================================================
  void changeDoctorPassword() async {
    try {
      final String? username = await SessionManager.getUsername("doctor");
      final newPassword = passwordPasswLostControllerDoctor.text.trim();
      final confirmPassword = confirmPasswordControllerDoctor.text.trim();

      if (newPassword.isEmpty || confirmPassword.isEmpty) {
        Get.snackbar('Error', 'Todos los campos son requeridos', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (newPassword != confirmPassword) {
        Get.snackbar('Error', 'Las contraseñas no coinciden', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{7,}$');
      if (!regex.hasMatch(newPassword)) {
        Get.snackbar('Error', 'La contraseña debe tener al menos 7 caracteres, una mayúscula, una minúscula, un número y un carácter especial', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final responseCode = await _userDoctorServices.updatePassword({
        "username": username,
        "newPassword": newPassword,
      });

      if (responseCode == 200) {
        Get.snackbar("Éxito", "Contraseña cambiada correctamente", snackPosition: SnackPosition.BOTTOM);
        passwordPasswLostControllerDoctor.clear();
        confirmPasswordControllerDoctor.clear();
      } else {
        Get.snackbar("Error", "No se pudo cambiar la contraseña ($responseCode)", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Error inesperado: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ======================================================
  // Logout de doctor
  // ======================================================
  void logout() async {
    try {
      final responseCode = await _userDoctorServices.logOut();
      await SessionManager.clearSession("doctor");
      doctor = null;
      userDoctorModel.value = null;

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Cierre de sesión exitoso');
        UserDoctorServices().disconnectWS();
        Get.toNamed('/selectorMode');
      } else if (responseCode == 300) {
        Get.snackbar('Advertencia', errorMessage.value);
      } else {
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error: No se pudo conectar con la API';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
