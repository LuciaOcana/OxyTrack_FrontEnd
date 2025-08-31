import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mioxi_frontend/models/user.dart';
import 'package:mioxi_frontend/services/userServices.dart';
import 'package:mioxi_frontend/screen/homePageScreen.dart';
import 'package:mioxi_frontend/controllers/userController.dart';

class logInScreen extends StatefulWidget {
  @override
  _logInScreenState createState() => _logInScreenState();
}
bool _obscurePassword = true; // 👈 estado para controlar visibilidad

class _logInScreenState extends State<logInScreen> {
  // 🔑 Claves separadas para cada formulario
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordLostFormKey = GlobalKey<FormState>();

 final UserServices _userServices = UserServices();
  final UserController _userController = UserController();

  // 🎨 Función para decoración dinámica de inputs
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

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _usernameControllerR = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _passwordControllerR = TextEditingController();

 

  void _register() async {
    if (_registerFormKey.currentState!.validate()) {
      UserModel newUser = UserModel(
        username: _usernameControllerR.text,
        email: _emailController.text,
        name: _nameController.text,
        lastname: _lastnameController.text,
        birthDate: _birthDateController.text,
        age: _ageController.text.isEmpty ? null : _ageController.text,
        height: _heightController.text,
        weight: _weightController.text,
        medication: _medicationController.text.isEmpty
            ? []
            : _medicationController.text.split(','),
        password: _passwordControllerR.text,
      );

      int statusCode = await _userServices.createUser(newUser);

      if (statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario creado exitosamente')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al crear el usuario')));
      }
    }
  }


void _showRegisterDialog(bool isLight, Color dialogBg, Color textColor, Color buttonColor) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.75, // 👈 limita el alto
      child: SingleChildScrollView( // 👈 agrega scroll si se pasa
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Registro de usuario',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textColor),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                child: Form(
                  key: _registerFormKey, // ✅ Clave separada
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _userController.usernameController,
                        decoration: _inputDecoration('Nombre de usuario', isLight),
                        validator: (value) =>
                            value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _userController.emailController,
                        decoration: _inputDecoration('Correo electrónico', isLight),
                        validator: (value) =>
                            value!.isEmpty ? 'Campo requerido' : null,
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
                        decoration: _inputDecoration('Fecha de nacimiento', isLight).copyWith(
    hintText: 'dd/mm/yyyy', // 👈 Aparece dentro del campo
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),  ),
),
                      
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _userController.heightController,
                        decoration: _inputDecoration('Altura', isLight).copyWith(
    hintText: 'en cm', // 👈 Aparece dentro del campo
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),  ),
),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _userController.weightController,
                        decoration: _inputDecoration('Peso', isLight).copyWith(
    hintText: 'en kg', // 👈 Aparece dentro del campo
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),  ),
),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _userController.passwordController,
                          obscureText: _obscurePassword, // 👈 depende del estado
                        decoration: _inputDecoration('Contraseña', isLight),
                        validator: (value) =>
                            value!.isEmpty ? 'Campo requerido' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancelar', style: TextStyle(color: textColor)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      _userController.signUp();
                      //_register();
                      Navigator.of(context).pop();
                    },
                    child: Text('Registrar', style: TextStyle(color: textColor)),
                  ),
                ],
              ),
            ],
          ),
        ),
          ),
        ),
      );
    },
  );
}

void _showPasswordLostDialog(bool isLight, Color dialogBg, Color textColor, Color buttonColor) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reinicio de contraseña',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textColor,
),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                child: Form(
                  key: _passwordLostFormKey, // ✅ Clave separada
                  child: Column(
                    children: [
                      TextFormField(
                        controller:
                            _userController.usernamePasswLostController,
                        decoration: _inputDecoration('Nombre de usuario', isLight),
                        validator: (value) =>
                            value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller:
                            _userController.passwordPasswLostController,
                        obscureText: true,
                        decoration: _inputDecoration('Contraseña', isLight),
                        validator: (value) =>
                            value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _userController.confirmPasswordController,
                        obscureText: true,
                        decoration: _inputDecoration('Confirmar contraseña', isLight),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo requerido';
                          }
                          if (value !=
                              _userController.passwordPasswLostController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancelar', style: TextStyle(color: textColor)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
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
                    onPressed: () {
                      if (_passwordLostFormKey.currentState!.validate()) {
                        // ✅ Solo se envía si pasa la validación
                        _userController.changePassword();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Registrar', style: TextStyle(color: textColor)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _guestPatient (){
_userController.logInGuest();
}

   @override
  Widget build(BuildContext context) {

  final isLight = Theme.of(context).brightness == Brightness.light;

    // 🎨 Colores dinámicos
    final appBarColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final buttonColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final altButtonBg = isLight ? const Color(0xFFCAF0F8) : const Color(0xFF001d3d);
    final altButtonText = isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final titleColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final textColor = isLight ? Colors.black87 : Colors.white;
    final dialogBg = isLight ? Colors.white : const Color(0xFF1E1E1E);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de sesión de usuario'),
        backgroundColor: appBarColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
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
              key: _loginFormKey, // ✅ Clave separada
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 26,
                      color: titleColor,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _userController.usernameLogInController,
                    decoration: _inputDecoration('Nombre de usuario', isLight),
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese su usuario' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userController.passwordLogInController,
                    decoration: _inputDecoration('Contraseña', isLight),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese su contraseña' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _userController.logIn();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCAF0F8),
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _guestPatient,
                    child: const Text(
                      'Entrar como invitado',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCAF0F8),
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showRegisterDialog(isLight, dialogBg, textColor, buttonColor),
                    child: const Text(
                      'Registro',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCAF0F8),
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: altButtonBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showPasswordLostDialog(isLight, dialogBg, textColor, buttonColor),
                    child: Text(
                      'He olvidado mi contraseña',
                      style: TextStyle(
                        fontSize: 18,
                        color:  altButtonText,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
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
