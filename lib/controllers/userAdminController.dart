import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // 👈 para listEquals

import 'package:oxytrack_frontend/services/userAdminServices.dart';
import 'package:oxytrack_frontend/models/user.dart';
import 'package:oxytrack_frontend/models/userDoctor.dart';
import 'package:oxytrack_frontend/services/userDoctorServices.dart';
import 'package:oxytrack_frontend/others/sessionManager.dart';
import 'package:oxytrack_frontend/auth/tokenManager.dart';


class UserAdminController extends GetxController {
  final UserAdminServices _userAdminServices = Get.put(UserAdminServices());
  final UserDoctorServices _userDoctorServices = Get.put(UserDoctorServices());

  // Variables del Log In de usuario
  final TextEditingController usernameAdminController = TextEditingController();
  final TextEditingController passwordAdminController = TextEditingController();

  // Variables del registro de doctor
  final TextEditingController usernameDoctorController =
      TextEditingController();
  final TextEditingController emailDoctorController = TextEditingController();
  final TextEditingController nameDoctorController = TextEditingController();
  final TextEditingController lastnameDoctorController =
      TextEditingController();
  var selectedPatients = <String>[].obs;

  final TextEditingController passwordDoctorController =
      TextEditingController();

      // Variables del Edit de doctor
  final TextEditingController usernameDoctorControllerEdit =
      TextEditingController();
  final TextEditingController emailDoctorControllerEdit = TextEditingController();
  final TextEditingController nameDoctorControllerEdit = TextEditingController();
  final TextEditingController lastnameDoctorControllerEdit =
      TextEditingController();
  var selectedPatientsEdit = <String>[].obs;

  final TextEditingController passwordDoctorControllerEdit =
      TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final tokenManager = TokenManager();
  var patientsList = <String>[].obs; // Lista reactiva
  // ✅ Pacientes seleccionados como lista reactiva

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


  // Registro de usuario

  Future<bool> signUp() async {
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
      return false;
    }

    // Validación de formato de correo electrónico
    if (!GetUtils.isEmail(emailDoctorControllerEdit.text)) {
      errorMessage.value = 'Correo electrónico no válido';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // Validación de contraseña segura
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    if (!regex.hasMatch(passwordDoctorControllerEdit.text)) {
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
      print('----------------- ${response}');

      if (response != null && response == 201) {
        Get.snackbar('Éxito', 'Doctor creado exitosamente');
        return true;
      } else {
        errorMessage.value =
            'Error: Este E-Mail o nombre de doctor ya están en uso';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error al registrar usuario';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateDoctor(String originalUsername, Map<String, dynamic> updatedFieldsFromDialog) async {
  try {

 // Construimos los campos a enviar directamente
    final Map<String, dynamic> updatedFields = {
      "username": updatedFieldsFromDialog["username"]?.trim() ?? "",
      "email": updatedFieldsFromDialog["email"]?.trim() ?? "",
      "name": updatedFieldsFromDialog["name"]?.trim() ?? "",
      "lastname": updatedFieldsFromDialog["lastname"]?.trim() ?? "",
      "patients": updatedFieldsFromDialog["patients"] ?? [],
      "password": updatedFieldsFromDialog["password"]?.trim() ?? "",
    };


    // Validación de formato de correo electrónico
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

    if (updatedFields.isEmpty) {
      Get.snackbar('Info', 'No se han realizado cambios');
      return false;
    }

    final responseCode =
        await _userAdminServices.editDoctor(originalUsername, updatedFields);

    print('----------------- $responseCode');

    if (responseCode == 200 || responseCode == 201) {
      Get.snackbar('Éxito', 'Doctor editado exitosamente');
      return true;
    } else {
      errorMessage.value =
          'Error: Este E-Mail o nombre de doctor ya están en uso';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  } catch (e) {
    errorMessage.value = 'Error al actualizar doctor';
    Get.snackbar(
      'Error',
      errorMessage.value,
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  } finally {
    isLoading.value = false;
  }
}



  Future<void> loadPatients() async {
  try {
    final patients = await _userAdminServices.getUsersWNDoctor(); // Debe devolver lista de nombres
    patientsList.value = patients; // Actualiza la lista reactiva
    print("pacientes: $patients");
  } catch (e) {
    print("Error cargando pacientes: $e");
  }
}


  void logout() async {
    try {
      final responseCode = await _userAdminServices.logOut();
      // 🔹 Llamada correcta a función async
await SessionManager.clearSession("admin"); // 👈 solo borra la sesión del admin
      print('🔍 Respuesta del backend: $responseCode');
      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');

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
