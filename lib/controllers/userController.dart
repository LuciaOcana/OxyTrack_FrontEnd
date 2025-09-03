// ======================================================
// UserController: Controlador para usuario
// Maneja: Login, Registro, Edición, Cambio de contraseña y Logout
// ======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mioxi_frontend/models/user.dart';
import 'package:mioxi_frontend/services/userServices.dart';
import 'package:mioxi_frontend/services/userDoctorServices.dart';
import 'package:mioxi_frontend/services/irServices.dart';
import 'package:mioxi_frontend/others/sessionManager.dart';
import 'package:mioxi_frontend/auth/tokenManager.dart';

class UserController extends GetxController {
  // ------------------------------
  // Servicios y dependencias
  // ------------------------------
  final UserServices _userService = Get.put(UserServices());
  final UserDoctorServices _userDoctorServices = Get.put(UserDoctorServices());
  final IrService _irService = IrService();
  final tokenManager = TokenManager();

  // ------------------------------
  // Controladores de texto para Login
  // ------------------------------
  final TextEditingController usernameLogInController = TextEditingController();
  final TextEditingController passwordLogInController = TextEditingController();

  // ------------------------------
  // Controladores de texto para Registro
  // ------------------------------
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ------------------------------
  // Controladores de texto para Edición
  // ------------------------------
  final TextEditingController usernameControllerEdit = TextEditingController();
  final TextEditingController emailControllerEdit = TextEditingController();
  final TextEditingController nameControllerEdit = TextEditingController();
  final TextEditingController lastnameControllerEdit = TextEditingController();
  final TextEditingController birthDateControllerEdit = TextEditingController();
  final TextEditingController heightControllerEdit = TextEditingController();
  final TextEditingController weightControllerEdit = TextEditingController();
  final TextEditingController medicationControllerEdit = TextEditingController();
  final TextEditingController passwordControllerEdit = TextEditingController();

  // ------------------------------
  // Controladores de texto para Recuperar Contraseña
  // ------------------------------
  final TextEditingController usernamePasswLostController = TextEditingController();
  final TextEditingController passwordPasswLostController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // ------------------------------
  // Variables reactivas
  // ------------------------------
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<UserModel> userModel = Rxn<UserModel>();
  UserModel? user;

  // ======================================================
  // Funciones de sesión
  // ======================================================

  // Guardar datos del usuario en SharedPreferences
  Future<void> saveUserSession(UserModel user, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name_$role', user.name);
    await prefs.setString('user_email_$role', user.email);
    await prefs.setString('user_role_$role', role);
  }

  // Obtener usuario desde backend y guardar en controlador
  Future<UserModel?> fetchUser(String role) async {
    try {
      final username = await SessionManager.getUsername(role);
      if (username != null) {
        user = await _userService.getUser(username);
        userModel.value = user;
        return user;
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
  // Login
  // ======================================================
  void logIn() async {
    if (usernameLogInController.text.isEmpty || passwordLogInController.text.isEmpty) {
      Get.snackbar('Error', 'Campos vacíos', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final logIn = (username: usernameLogInController.text, password: passwordLogInController.text);
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final responseCode = await _userService.logIn(logIn);
      final token = await tokenManager.getToken();

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
        await SessionManager.saveSession("user", token, usernameLogInController.text);
        _irService.connect();
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

  void logInGuest() async {
    final logInGuest = (username: "GuestPatient", password: "123456Aa%");
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final responseCode = await _userService.logIn(logInGuest);
      final token = await tokenManager.getToken();

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso, iniciando la lectura');
        Get.toNamed('/homeGuest');
        await SessionManager.saveSession("user", token, "GuestPatient");
        _irService.connect();
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
  // Registro de usuario
  // ======================================================
  void signUp() async {
    // Validaciones de campos
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        birthDateController.text.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty) {
      errorMessage.value = 'Campos vacíos';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      errorMessage.value = 'Correo electrónico no válido';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{7,}$');
    if (!regex.hasMatch(passwordController.text)) {
      errorMessage.value =
          'La contraseña debe tener al menos 7 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final dateRegex = RegExp(r'^([0-2][0-9]|3[0-1])/([0][1-9]|1[0-2])/(\d{4})$');
    if (!dateRegex.hasMatch(birthDateController.text)) {
      errorMessage.value = 'Fecha inválida. Formato correcto: dd/mm/yyyy';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Validar fecha real
    try {
      final parts = birthDateController.text.split('/');
      final date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      if (date.day != int.parse(parts[0]) || date.month != int.parse(parts[1]) || date.year != int.parse(parts[2])) {
        throw Exception();
      }
    } catch (e) {
      errorMessage.value = 'Fecha inválida. Verifica los valores';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final newUser = UserModel(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        lastname: lastnameController.text.trim(),
        birthDate: birthDateController.text.trim(),
        age: "",
        height: heightController.text.trim(),
        weight: weightController.text.trim(),
        medication: [],
        doctor: "",
        password: passwordController.text.trim(),
      );

      final responseCode = await _userService.createUser(newUser);

      if (responseCode != null && responseCode == 201) {
        Get.snackbar('Éxito', 'Usuario creado exitosamente');
        Get.toNamed('/login');
      } else {
        errorMessage.value = 'Error: Este E-Mail o nombre de usuario ya están en uso';
        Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // Actualizar usuario
  // ======================================================
  Future<bool> updateUser(String originalUsername, Map<String, dynamic> updatedFieldsFromDialog) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> updatedFields = {
        "username": updatedFieldsFromDialog["username"]?.trim() ?? "",
        "email": updatedFieldsFromDialog["email"]?.trim() ?? "",
        "name": updatedFieldsFromDialog["name"]?.trim() ?? "",
        "lastname": updatedFieldsFromDialog["lastname"]?.trim() ?? "",
        "birthDate": updatedFieldsFromDialog["birthDate"]?.trim() ?? "",
        "age": updatedFieldsFromDialog["age"] ?? "",
        "height": updatedFieldsFromDialog["height"]?.trim() ?? "",
        "weight": updatedFieldsFromDialog["weight"]?.trim() ?? "",
        "medication": updatedFieldsFromDialog["medication"] ?? [],
        "doctor": updatedFieldsFromDialog["doctor"] ?? "",
        "password": updatedFieldsFromDialog["password"]?.trim() ?? "",
      };

      // Validaciones de email y password
      if (updatedFields["email"].isNotEmpty && !GetUtils.isEmail(updatedFields["email"])) {
        errorMessage.value = 'Correo electrónico no válido';
        Get.snackbar('Error', errorMessage.value);
        return false;
      }

      if (updatedFields["password"].isNotEmpty) {
        final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{7,}$');
        if (!regex.hasMatch(updatedFields["password"])) {
          errorMessage.value =
              'La contraseña debe tener al menos 7 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
          Get.snackbar('Error', errorMessage.value);
          return false;
        }
      }

      // Validación de fecha
      if (updatedFields["birthDate"].isNotEmpty) {
        final dateRegex = RegExp(r'^([0-2][0-9]|3[0-1])/([0][1-9]|1[0-2])/(\d{4})$');
        final birthDate = updatedFields["birthDate"];
        if (!dateRegex.hasMatch(birthDate)) {
          errorMessage.value = 'Fecha inválida. Formato correcto: dd/mm/yyyy';
          Get.snackbar('Error', errorMessage.value);
          return false;
        }
        try {
          final parts = birthDate.split('/');
          final date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          if (date.day != int.parse(parts[0]) || date.month != int.parse(parts[1]) || date.year != int.parse(parts[2])) {
            throw Exception();
          }
        } catch (_) {
          errorMessage.value = 'Fecha inválida. Verifica los valores';
          Get.snackbar('Error', errorMessage.value);
          return false;
        }
      }

      if (updatedFields["username"] != originalUsername) {
        final currentToken = await tokenManager.getToken();
        await SessionManager.saveSession("user", currentToken, updatedFields["username"]);
      }

      final responseCode = await _userService.editUser(originalUsername, updatedFields);

      if (responseCode == 200 || responseCode == 201) {
        Get.snackbar('Éxito', 'Usuario editado exitosamente');
        await fetchUser("user");
        return true;
      } else {
        errorMessage.value = 'Error: Este E-Mail o nombre ya están en uso';
        Get.snackbar('Error', errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error al actualizar usuario';
      Get.snackbar('Error', errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateUserByDoctor(String originalUsername, Map<String, dynamic> updatedFieldsFromDialog) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> updatedFields = {
        "username": updatedFieldsFromDialog["username"]?.trim() ?? "",
        "email": updatedFieldsFromDialog["email"]?.trim() ?? "",
        "name": updatedFieldsFromDialog["name"]?.trim() ?? "",
        "lastname": updatedFieldsFromDialog["lastname"]?.trim() ?? "",
        "birthDate": updatedFieldsFromDialog["birthDate"]?.trim() ?? "",
        "age": updatedFieldsFromDialog["age"] ?? "",
        "height": updatedFieldsFromDialog["height"]?.trim() ?? "",
        "weight": updatedFieldsFromDialog["weight"]?.trim() ?? "",
        "medication": updatedFieldsFromDialog["medication"] ?? [],
        "doctor": updatedFieldsFromDialog["doctor"] ?? "",
        "password": updatedFieldsFromDialog["password"]?.trim() ?? "",
      };

      final responseCode = await _userDoctorServices.editUser(originalUsername, updatedFields);

      if (responseCode == 200 || responseCode == 201) {
        Get.snackbar('Éxito', 'Usuario editado exitosamente por el doctor');
        await fetchUser("user");
        return true;
      } else {
        errorMessage.value = 'Error: Este E-Mail o nombre ya están en uso';
        Get.snackbar('Error', errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error al actualizar usuario';
      Get.snackbar('Error', errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // Cambiar contraseña
  // ======================================================
  void changePassword() async {
    try {
      final username = usernamePasswLostController.text.trim();
      final newPassword = passwordPasswLostController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (username.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
        Get.snackbar('Error', 'Todos los campos son requeridos', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (newPassword != confirmPassword) {
        Get.snackbar('Error', 'Las contraseñas no coinciden', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{7,}$');
      if (!regex.hasMatch(newPassword)) {
        Get.snackbar('Error', 'Contraseña insegura', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final responseCode = await _userService.updatePassword({
        "username": username,
        "newPassword": newPassword,
      });

      if (responseCode == 200) {
        Get.snackbar("Éxito", "Contraseña cambiada correctamente", snackPosition: SnackPosition.BOTTOM);
        usernamePasswLostController.clear();
        passwordPasswLostController.clear();
        passwordController.clear();
      } else {
        Get.snackbar("Error", "No se pudo cambiar la contraseña ($responseCode)", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Error inesperado: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ======================================================
  // Logout
  // ======================================================
  void logout() async {
    try {
      isLoading.value = true;
      final responseCode = await _userService.logOut();

      await SessionManager.clearSession("user");
      user = null;
      userModel.value = null;

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Cierre de sesión exitoso');
        IrService().disconnect();
        Get.offAllNamed('/selectorMode');
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
