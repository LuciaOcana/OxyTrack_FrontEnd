import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:oxytrack_frontend/services/userServices.dart';
import 'package:oxytrack_frontend/models/user.dart';
import 'package:oxytrack_frontend/others/sessionManager.dart';
import 'package:oxytrack_frontend/auth/tokenManager.dart';
import 'package:oxytrack_frontend/services/irServices.dart';



class UserController extends GetxController {
  final UserServices _userService = Get.put(UserServices());
  final IrService _irService = IrService();

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

   // Variables del edit de usuario
  final TextEditingController usernameControllerEdit = TextEditingController();
  final TextEditingController emailControllerEdit = TextEditingController();
  final TextEditingController nameControllerEdit = TextEditingController();
  final TextEditingController lastnameControllerEdit = TextEditingController();
  final TextEditingController birthDateControllerEdit =
      TextEditingController(); // en formato yyyy-MM-dd
  final TextEditingController heightControllerEdit = TextEditingController();
  final TextEditingController weightControllerEdit = TextEditingController();
  final TextEditingController passwordControllerEdit = TextEditingController();


final TextEditingController usernamePasswLostController = TextEditingController();
  final TextEditingController passwordPasswLostController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();



  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
    final tokenManager = TokenManager();
  final Rxn<UserModel> userModel = Rxn<UserModel>();

// Funcion para guardar el usuario en el sharedPreference
Future<void> saveUserSession(UserModel user, String role) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('user_name', user.name);
  prefs.setString('user_email', user.email);
  prefs.setString('user_role', 'user'); // 'user', 'admin', 'doctor'
}
 
/// Obtiene el usuario desde el backend y lo guarda en el controlador
  Future<UserModel?> fetchUser() async {
    try {
      final username = await SessionManager.getUsername();
      if (username != null) {
        final user = await _userService.getUser(username);
        userModel.value = user;
        return user;
      } else {
        print('No se encontró el username en sesión');
        return null;
      }
    } catch (e) {
      print('Error al obtener el usuario: $e');
      return null;
    }
  }

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
      final responseCode = await _userService.logIn(logIn);
      final token =
          await tokenManager.getToken(); // 🔹 recupera el token guardado

      print('🔍 Respuesta del backend: $responseCode');

      if (responseCode == 200) {
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
        await SessionManager.saveSession(
          "user",
          token,
          usernameLogInController.text,
        );
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

    // Validación de formato de correo electrónico
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
    }

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

      final response = await _userService.createUser(newUser);
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


  Future<bool> updateUser(String originalUsername, UserModel originalDoctor) async {
  try {
    isLoading.value = true;
    final Map<String, dynamic> updatedFields = {};

    // 👇 Solo validamos si el email fue modificado
    if (emailControllerEdit.text.trim().isNotEmpty &&
        emailControllerEdit.text.trim() != originalDoctor.email) {
      if (!GetUtils.isEmail(emailControllerEdit.text.trim())) {
        errorMessage.value = 'Correo electrónico no válido';
        Get.snackbar('Error', errorMessage.value,
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
      updatedFields["email"] = emailControllerEdit.text.trim();
    }

    // 👇 Solo validamos si la contraseña fue modificada
    if (passwordControllerEdit.text.trim().isNotEmpty) {
      final regex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
      if (!regex.hasMatch(passwordControllerEdit.text.trim())) {
        errorMessage.value =
            'La contraseña debe tener al menos 7 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
        Get.snackbar('Error', errorMessage.value,
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
      updatedFields["password"] = passwordControllerEdit.text.trim();
    }

    if (usernameControllerEdit.text.trim().isNotEmpty &&
        usernameControllerEdit.text.trim() != originalDoctor.username) {
      updatedFields["username"] = usernameControllerEdit.text.trim();
    }

    if (nameControllerEdit.text.trim().isNotEmpty &&
        nameControllerEdit.text.trim() != originalDoctor.name) {
      updatedFields["name"] = nameControllerEdit.text.trim();
    }

    if (lastnameControllerEdit.text.trim().isNotEmpty &&
        lastnameControllerEdit.text.trim() != originalDoctor.lastname) {
      updatedFields["lastname"] = lastnameControllerEdit.text.trim();
    }

    if (birthDateControllerEdit.text.trim().isNotEmpty &&
        birthDateControllerEdit.text.trim() != originalDoctor.birthDate) {
      updatedFields["birthDate"] = birthDateControllerEdit.text.trim();
    }

    if (heightControllerEdit.text.trim().isNotEmpty &&
        heightControllerEdit.text.trim() != originalDoctor.height) {
      updatedFields["height"] = heightControllerEdit.text.trim();
    }

    if (weightControllerEdit.text.trim().isNotEmpty &&
        weightControllerEdit.text.trim() != originalDoctor.weight) {
      updatedFields["weight"] = weightControllerEdit.text.trim();
    }

    // 🚨 Si no hay cambios
    if (updatedFields.isEmpty) {
      Get.snackbar('Info', 'No se han realizado cambios');
      return false;
    }

    print('----------------- $updatedFields');

    final responseCode =
        await _userService.editUser(originalUsername, updatedFields);

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

void changePassword() async {
  try {
    final username = usernamePasswLostController.text.trim();
    final newPassword = passwordPasswLostController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validaciones
    if (username.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Todos los campos son requeridos',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Las contraseñas no coinciden',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    if (!regex.hasMatch(newPassword)) {
      Get.snackbar(
          'Error',
          'La contraseña debe tener al menos 7 caracteres, una mayúscula, una minúscula, un número y un carácter especial',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 🚀 Llamada al service con el body
    final responseCode = await _userService.updatePassword({
      "username": username,
      "newPassword": newPassword,
    });

print(responseCode);
    if (responseCode == 200) {
      Get.snackbar("Éxito", "Contraseña cambiada correctamente",
          snackPosition: SnackPosition.BOTTOM);
      usernamePasswLostController.clear();
      passwordPasswLostController.clear();
      passwordController.clear();
    } else {
      Get.snackbar("Error", "No se pudo cambiar la contraseña ($responseCode)",
          snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    Get.snackbar("Error", "Error inesperado: $e",
        snackPosition: SnackPosition.BOTTOM);
  }
}


  void logout() async {
    try {
      final responseCode = await _userService.logOut();
      // 🔹 Llamada correcta a función async
      await SessionManager.clearSession();
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
