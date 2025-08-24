import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oxytrack_frontend/services/irServices.dart';
import 'package:oxytrack_frontend/controllers/userController.dart';
import 'package:oxytrack_frontend/services/userServices.dart';
import 'package:oxytrack_frontend/others/sessionManager.dart';
import 'package:oxytrack_frontend/models/user.dart';
import 'package:oxytrack_frontend/others/themeController.dart';


class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
final RxBool isLoading = false.obs; // Defínelo dentro de _UserProfileScreenState


  final UserController _userController = Get.put(UserController());
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    loadUserData();
    IrService().connect();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
final username = await SessionManager.getUsername("user");
    if (username != null) {
final fetchedUser = await _userController.fetchUser("user");
      if (fetchedUser != null) {
        userModel = fetchedUser;
        name.value = userModel!.name;
        email.value = userModel!.email;
      }
    }
    isLoading.value = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

  final isLight = Theme.of(context).brightness == Brightness.light;

    // 🎨 Colores dinámicos
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

    if (userModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
          leading: IconButton(
          icon: Icon(
            isLight ? Icons.dark_mode : Icons.light_mode,
            color: Colors.white,
          ),
          onPressed: () => Get.find<ThemeController>().toggleTheme(),
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFe2fdff)),
            tooltip: 'Cerrar sesión',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userModel == null) {
          return const Center(child: Text('No se pudo cargar el usuario'));
        }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("👤", style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Obx(
                () => Text(
                  name.value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  email.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  if (userModel != null) {
                    _showEditDialog(
                      context,
                      userModel!,
                      _userController,
                      
                      () async {
                        await loadUserData();
                      },
                      textColor
                    );
                  } else {
                    Get.snackbar('Error', 'No se pudo cargar el usuario');
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }


  void _showLogoutDialog(BuildContext context) {
     final isLight = Theme.of(context).brightness == Brightness.light;

        final textColor = isLight ? Colors.black87 : Colors.white;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Text(
            "¿Estás segura de que quieres cerrar sesión?",
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontFamily: 'OpenSans',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE4E1)),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFB31B1B),
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _userController.logout();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB31B1B)),
              child: const Text(
                "Cerrar sesión",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFFFE4E1),
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

void _showEditDialog(
  BuildContext context,
  UserModel user,
  UserController userController,
  VoidCallback onSaved,
  Color textColor
) {
  // Inicializamos los controladores con los datos actuales
  userController.usernameControllerEdit.text = user.username;
  userController.emailControllerEdit.text = user.email;
  userController.nameControllerEdit.text = user.name;
  userController.lastnameControllerEdit.text = user.lastname;
  userController.birthDateControllerEdit.text = user.birthDate;
  userController.heightControllerEdit.text = user.height;
  userController.weightControllerEdit.text = user.weight;
  userController.passwordControllerEdit.text = "";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Editar perfil',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: userController.usernameControllerEdit,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: userController.emailControllerEdit,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: userController.nameControllerEdit,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: userController.lastnameControllerEdit,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                ),
                TextField(
                  controller: userController.birthDateControllerEdit,
                  decoration: const InputDecoration(labelText: 'Fecha de nacimiento'),
                ),
                TextField(
                  controller: userController.heightControllerEdit,
                  decoration: const InputDecoration(labelText: 'Altura'),
                ),
                TextField(
                  controller: userController.weightControllerEdit,
                  decoration: const InputDecoration(labelText: 'Peso'),
                ),
                TextField(
                  controller: userController.passwordControllerEdit,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: TextStyle(color: textColor)),
          ),
          ElevatedButton(
            onPressed: () async {
              final dialogLoading = ValueNotifier(false);
    dialogLoading.value = true;
              print("🔹 Botón Guardar presionado");

              // Construimos el mapa completo para enviar al backend
              final updatedFields = {
                "username": userController.usernameControllerEdit.text.trim().isNotEmpty
                    ? userController.usernameControllerEdit.text.trim()
                    : user.username,
                "email": userController.emailControllerEdit.text.trim().isNotEmpty
                    ? userController.emailControllerEdit.text.trim()
                    : user.email,
                "name": userController.nameControllerEdit.text.trim().isNotEmpty
                    ? userController.nameControllerEdit.text.trim()
                    : user.name,
                "lastname": userController.lastnameControllerEdit.text.trim().isNotEmpty
                    ? userController.lastnameControllerEdit.text.trim()
                    : user.lastname,
                "birthDate": userController.birthDateControllerEdit.text.trim().isNotEmpty
                    ? userController.birthDateControllerEdit.text.trim()
                    : user.birthDate,
                "age": user.age ?? "",
                "height": userController.heightControllerEdit.text.trim().isNotEmpty
                    ? userController.heightControllerEdit.text.trim()
                    : user.height,
                "weight": userController.weightControllerEdit.text.trim().isNotEmpty
                    ? userController.weightControllerEdit.text.trim()
                    : user.weight,
                "medication": user.medication ?? [""],
                "doctor": user.doctor ?? "",
                "password": userController.passwordControllerEdit.text.trim().isNotEmpty
                    ? userController.passwordControllerEdit.text.trim()
                    : user.password,
              };

              print("🔹 Campos enviados al backend: $updatedFields");

              final success = await userController.updateUser(user.username, updatedFields);
              print("🔹 Resultado de updateUser: $success");
                  dialogLoading.value = false;

              if (success) {
                Navigator.of(context).pop();
                onSaved();
              } else {
                Get.snackbar('Error', 'No se pudo actualizar el usuario');
              }
            },
            child: Text('Guardar', style: TextStyle(color: textColor)),
          ),
        ],
      );
    },
  );
}

