// ======================================================
// logInScreen.dart
// Pantalla de inicio de sesión, registro y recuperación de contraseña
// ======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mioxi_frontend/controllers/userController.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final UserController _userController = Get.put(UserController());

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _passwordLostFormKey = GlobalKey<FormState>();

  // Declaración dentro de tu State
final RxBool _obscurePasswordLogin = true.obs;      // Para login
final RxBool _obscurePasswordRegister = true.obs;   // Para registro
final RxBool _obscurePasswordLost = true.obs;       // Para reinicio de contraseña
final RxBool _obscureConfirmPasswordLost = true.obs; // Para confirmación de contraseña en reinicio


  InputDecoration _inputDecoration(String label, bool isLight) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isLight ? Colors.grey[100] : Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _guestPatient() {
    _userController.logInGuest();
  }

  void _showRegisterDialog(
    bool isLight,
    Color dialogBg,
    Color textColor,
    Color buttonColor,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: dialogBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isLight ? Colors.black12 : Colors.black45,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Registro de usuario',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _registerFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _userController.usernameController,
                              decoration: _inputDecoration(
                                'Nombre de usuario',
                                isLight,
                              ),
                              validator:
                                  (v) => v!.isEmpty ? 'Campo requerido' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _userController.emailController,
                              decoration: _inputDecoration(
                                'Correo electrónico',
                                isLight,
                              ),
                              validator:
                                  (v) => v!.isEmpty ? 'Campo requerido' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _userController.nameController,
                              decoration: _inputDecoration('Nombre', isLight),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _userController.lastnameController,
                              decoration: _inputDecoration('Apellido', isLight),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _userController.birthDateController,
                              decoration: _inputDecoration(
                                'Fecha de nacimiento',
                                isLight,
                              ).copyWith(
                                hintText: 'dd/mm/yyyy',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _userController.heightController,
                              decoration: _inputDecoration(
                                'Altura',
                                isLight,
                              ).copyWith(
                                hintText: 'en cm',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _userController.weightController,
                              decoration: _inputDecoration(
                                'Peso',
                                isLight,
                              ).copyWith(
                                hintText: 'en kg',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Obx(
  () => TextFormField(
    controller: _userController.passwordLogInController,
    obscureText: _obscurePasswordRegister.value,
    decoration: _inputDecoration('Contraseña', isLight).copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePasswordRegister.value ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () => _obscurePasswordRegister.value = !_obscurePasswordRegister.value,
      ),
    ),
    validator: (v) => v!.isEmpty ? 'Ingrese su contraseña' : null,
  ),
),

                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              _userController.signUp();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              'Registrar',
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void _showPasswordLostDialog(
    bool isLight,
    Color dialogBg,
    Color textColor,
    Color buttonColor,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: dialogBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isLight ? Colors.black12 : Colors.black45,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reinicio de contraseña',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _passwordLostFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller:
                              _userController.usernamePasswLostController,
                          decoration: _inputDecoration(
                            'Nombre de usuario',
                            isLight,
                          ),
                          validator:
                              (v) => v!.isEmpty ? 'Campo requerido' : null,
                        ),
                        const SizedBox(height: 12),
                        Obx(
  () => TextFormField(
    controller: _userController.passwordPasswLostController,
    obscureText: _obscurePasswordLost.value,
    decoration: _inputDecoration('Contraseña', isLight).copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePasswordLost.value ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () => _obscurePasswordLost.value = !_obscurePasswordLost.value,
      ),
    ),
    validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
  ),
),

                        const SizedBox(height: 12),
                        Obx(
  () => TextFormField(
    controller: _userController.confirmPasswordController,
    obscureText: _obscureConfirmPasswordLost.value,
    decoration: _inputDecoration('Confirmar contraseña', isLight).copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPasswordLost.value ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () => _obscureConfirmPasswordLost.value = !_obscureConfirmPasswordLost.value,
      ),
    ),
    validator: (v) {
      if (v == null || v.isEmpty) return 'Campo requerido';
      if (v != _userController.passwordPasswLostController.text) return 'Las contraseñas no coinciden';
      return null;
    },
  ),
),


                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_passwordLostFormKey.currentState!.validate()) {
                            _userController.changePassword();
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Registrar',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final appBarColor =
        isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final buttonColor =
        isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final altButtonBg =
        isLight ? const Color(0xFFCAF0F8) : const Color(0xFF001d3d);
    final altButtonText =
        isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final titleColor =
        isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final textColor = isLight ? Colors.black87 : Colors.white;
    final dialogBg = isLight ? Colors.white : const Color(0xFF1E1E1E);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de sesión de usuario'),
        backgroundColor: appBarColor,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 26,
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _userController.usernameLogInController,
                    decoration: _inputDecoration('Nombre de usuario', isLight),
                    validator: (v) => v!.isEmpty ? 'Ingrese su usuario' : null,
                  ),
                  const SizedBox(height: 16),
                   Obx(
  () => TextFormField(
    controller: _userController.passwordLogInController,
    obscureText: _obscurePasswordLogin.value,
    decoration: _inputDecoration('Contraseña', isLight).copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePasswordLogin.value ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () => _obscurePasswordLogin.value = !_obscurePasswordLogin.value,
      ),
    ),
    validator: (v) => v!.isEmpty ? 'Ingrese su contraseña' : null,
  ),
),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _userController.logIn(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCAF0F8),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _guestPatient,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Entrar como invitado',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCAF0F8),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => _showRegisterDialog(
                          isLight,
                          dialogBg,
                          textColor,
                          buttonColor,
                        ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Registro',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCAF0F8),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => _showPasswordLostDialog(
                          isLight,
                          dialogBg,
                          textColor,
                          buttonColor,
                        ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: altButtonBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'He olvidado mi contraseña',
                      style: TextStyle(
                        fontSize: 18,
                        color: altButtonText,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
