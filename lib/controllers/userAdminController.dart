// ------------------------------------------------------------
// UserAdminController: Controlador para la sección de administrador
// ------------------------------------------------------------
// Funciones principales:
// - Log in de administrador
// - Registro de nuevos doctores
// - Edición de datos de doctores
// - Gestión de pacientes
// - Logout de sesión
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // Para listEquals
import 'package:mioxi_frontend/services/userAdminServices.dart';
import 'package:mioxi_frontend/models/user.dart';
import 'package:mioxi_frontend/models/userDoctor.dart';
import 'package:mioxi_frontend/services/userDoctorServices.dart';
import 'package:mioxi_frontend/others/sessionManager.dart';
import 'package:mioxi_frontend/auth/tokenManager.dart';

class UserAdminController extends GetxController {
  // ------------------------------
  // Servicios
  // ------------------------------
  final UserAdminServices _userAdminServices = Get.put(UserAdminServices());
  final UserDoctorServices _userDoctorServices = Get.put(UserDoctorServices());

  // ------------------------------
  // Controladores de texto para login
  // ------------------------------
  final TextEditingController usernameAdminController = TextEditingController();
  final TextEditingController passwordAdminController = TextEditingController();

  // ------------------------------
  // Controladores de texto para registro de doctor
  // ------------------------------
  final TextEditingController usernameDoctorController = TextEditingController();
  final TextEditingController emailDoctorController = TextEditingController();
  final TextEditingController nameDoctorController = TextEditingController();
  final TextEditingController lastnameDoctorController = TextEditingController();
  var selectedPatients = <String>[].obs; // Pacientes seleccionados (reactivo)
  final TextEditingController passwordDoctorController = TextEditingController();

  // ------------------------------
  // Controladores de texto para edición de doctor
  // ------------------------------
  final TextEditingController usernameDoctorControllerEdit = TextEditingController();
  final TextEditingController emailDoctorControllerEdit = TextEditingController();
  final TextEditingController nameDoctorControllerEdit = TextEditingController();
  final TextEditingController lastnameDoctorControllerEdit = TextEditingController();
  var selectedPatientsEdit = <String>[].obs; // Pacientes seleccionados en edición
  final TextEditingController passwordDoctorControllerEdit = TextEditingController();

  // ------------------------------
  // Variables reactivas para UI
  // ------------------------------
  final RxBool isLoading = false.obs;         // Indicador de carga
  final RxString errorMessage = ''.obs;       // Mensajes de error
  final tokenManager = TokenManager();        // Manejo de JWT
  var patientsList = <String>[].obs;          // Lista reactiva de pacientes

  // ------------------------------------------------------------
  // Log in de administrador
  // ------------------------------------------------------------
  void logIn() async {
    if (usernameAdminController.text.isEmpty || passwordAdminController.text.isEmpty) {
      Get.snackbar('Error', 'Campos vacíos', snackPosition: SnackPosition.BOTTOM);
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
      final responseCode = await _userAdminServices.logIn(logInAdmin);
      final token = await tokenManager.getToken();

      print("Token disponible en controller: $token");
      print('🔍 Respuesta del backend: $responseCode');

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');

        await SessionManager.saveSession("admin", token, usernameAdminController.text);

        final savedToken = await SessionManager.getToken("admin");
        final savedUsername = await SessionManager.getUsername("admin");

        print("✅ Sesión guardada correctamente");
        print("Token: $savedToken");
        print("Username: $savedUsername");

        Get.toNamed('/adminDoctorListPage');
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

  // ------------------------------------------------------------
  // Registro de nuevo doctor
  // ------------------------------------------------------------
  Future<bool> signUp() async {
    // Validación de campos
    if (usernameDoctorController.text.isEmpty ||
        emailDoctorController.text.isEmpty ||
        nameDoctorController.text.isEmpty ||
        lastnameDoctorController.text.isEmpty ||
        passwordDoctorController.text.isEmpty) {
      errorMessage.value = 'Campos vacíos';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // Validación de email
    if (!GetUtils.isEmail(emailDoctorController.text)) {
      errorMessage.value = 'Correo electrónico no válido';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // Validación de contraseña segura
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    if (!regex.hasMatch(passwordDoctorController.text)) {
      errorMessage.value =
          'La contraseña debe tener al menos 7 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    isLoading.value = true;

    try {
      final newDoctor = UserDoctorModel(
        username: usernameDoctorController.text.trim(),
        email: emailDoctorController.text.trim(),
        name: nameDoctorController.text.trim(),
        lastname: lastnameDoctorController.text.trim(),
        patients: selectedPatients.isEmpty ? [] : selectedPatients.toList(),
        password: passwordDoctorController.text.trim(),
      );

      final response = await _userAdminServices.createDoctor(newDoctor);

      if (response != null && response == 201) {
        Get.snackbar('Éxito', 'Doctor creado exitosamente');
        return true;
      } else {
        errorMessage.value = 'Error: Este E-Mail o nombre de doctor ya están en uso';
        Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error al registrar usuario';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------------------------------------------
  // Actualizar datos de doctor
  // ------------------------------------------------------------
  Future<bool> updateDoctor(String originalUsername, Map<String, dynamic> updatedFieldsFromDialog) async {
    try {
      final Map<String, dynamic> updatedFields = {
        "username": updatedFieldsFromDialog["username"]?.trim() ?? "",
        "email": updatedFieldsFromDialog["email"]?.trim() ?? "",
        "name": updatedFieldsFromDialog["name"]?.trim() ?? "",
        "lastname": updatedFieldsFromDialog["lastname"]?.trim() ?? "",
        "patients": updatedFieldsFromDialog["patients"] ?? [],
        "password": updatedFieldsFromDialog["password"]?.trim() ?? "",
      };

      if (updatedFields.isEmpty) {
        Get.snackbar('Info', 'No se han realizado cambios');
        return false;
      }

      final responseCode = await _userAdminServices.editDoctor(originalUsername, updatedFields);

      if (responseCode == 200 || responseCode == 201) {
        Get.snackbar('Éxito', 'Doctor editado exitosamente');
        return true;
      } else {
        errorMessage.value = 'Error: Este E-Mail o nombre de doctor ya están en uso';
        Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error al actualizar doctor';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------------------------------------------
  // Cargar lista de pacientes
  // ------------------------------------------------------------
  Future<void> loadPatients() async {
    try {
      final patients = await _userAdminServices.getUsersWNDoctor(); // Lista de nombres
      patientsList.value = patients; // Actualiza lista reactiva
    } catch (e) {
      print("Error cargando pacientes: $e");
    }
  }

  // ------------------------------------------------------------
  // Cerrar sesión de administrador
  // ------------------------------------------------------------
  void logout() async {
    try {
      final responseCode = await _userAdminServices.logOut();
      await SessionManager.clearSession("admin"); // Borra solo sesión de admin

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Sesión cerrada correctamente');
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
