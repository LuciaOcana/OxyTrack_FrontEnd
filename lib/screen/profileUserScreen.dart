import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oxytrack_frontend/services/irServices.dart';
import 'package:oxytrack_frontend/controllers/userController.dart';
import 'package:oxytrack_frontend/services/userServices.dart';
import 'package:oxytrack_frontend/others/sessionManager.dart';
import 'package:oxytrack_frontend/models/user.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final UserController _userController = Get.put(UserController());

  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    loadUserData();
    IrService().connect();
  }

  Future<void> loadUserData() async {
    final username = await SessionManager.getUsername();
    if (username != null) {
      userModel = await _userController.fetchUser();
      if (userModel != null) {
        name.value = userModel!.name;
        email.value = userModel!.email;
      }
    }
    setState(() {});
  }



  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text("¿Estás segura de que quieres cerrar sesión?",
            style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB31B1B),
            ),
            onPressed: () {
              _userController.logout();
            },
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userModel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF0096C7),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("👤", style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Obx(() => Text(
                    name.value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  )),
              const SizedBox(height: 8),
              Obx(() => Text(
                    email.value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'OpenSans',
                    ),
                  )),
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
                    );
                  } else {
                    Get.snackbar('Error', 'No se pudo cargar el usuario');
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0096C7),
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
      ),
    );
  }
}

void _showEditDialog(
  BuildContext context,
  UserModel user,
  UserController userController,
  VoidCallback onSaved,
) {
  userController.usernameControllerEdit.text = user.username;
  userController.emailControllerEdit.text = user.email;
  userController.nameControllerEdit.text = user.name;
  userController.lastnameControllerEdit.text = user.lastname;
  userController.birthDateControllerEdit.text = user.birthDate;
  userController.heightControllerEdit.text = user.height;
  userController.weightControllerEdit.text = user.weight;
  userController.passwordControllerEdit.text = "";

  bool hasUserChanged(UserModel user, UserController controller) {
    return controller.usernameControllerEdit.text != user.username ||
        controller.emailControllerEdit.text != user.email ||
        controller.nameControllerEdit.text != user.name ||
        controller.lastnameControllerEdit.text != user.lastname ||
        controller.birthDateControllerEdit.text != user.birthDate ||
        controller.heightControllerEdit.text != user.height ||
        controller.weightControllerEdit.text != user.weight ||
        controller.passwordControllerEdit.text.isNotEmpty;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Editar Perfil',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            color: Color(0xFF0096C7),
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
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!hasUserChanged(user, userController)) {
                Get.snackbar('Sin cambios', 'No se ha modificado ningún dato');
                return;
              }

              final updatedUser = UserModel(
                username: userController.usernameControllerEdit.text.isNotEmpty
                    ? userController.usernameControllerEdit.text
                    : user.username,
                email: userController.emailControllerEdit.text.isNotEmpty
                    ? userController.emailControllerEdit.text
                    : user.email,
                name: userController.nameControllerEdit.text.isNotEmpty
                    ? userController.nameControllerEdit.text
                    : user.name,
                lastname: userController.lastnameControllerEdit.text.isNotEmpty
                    ? userController.lastnameControllerEdit.text
                    : user.lastname,
                birthDate: userController.birthDateControllerEdit.text.isNotEmpty
                    ? userController.birthDateControllerEdit.text
                    : user.birthDate,
                height: userController.heightControllerEdit.text.isNotEmpty
                    ? userController.heightControllerEdit.text
                    : user.height,
                weight: userController.weightControllerEdit.text.isNotEmpty
                    ? userController.weightControllerEdit.text
                    : user.weight,
                password: userController.passwordControllerEdit.text.isNotEmpty
                    ? userController.passwordControllerEdit.text
                    : user.password,
                medication: user.medication,
                doctor: user.doctor,
                age: user.age,
              );



              final success = await userController.updateUser(
                user.username,
                updatedUser,
              );

              if (success) {
                Navigator.of(context).pop();
                onSaved();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}
