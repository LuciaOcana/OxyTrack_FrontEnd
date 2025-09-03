import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/userDoctor.dart';
import 'package:mioxi_frontend/controllers/userDoctorController.dart';
import 'package:mioxi_frontend/services/userDoctorServices.dart';
import 'package:mioxi_frontend/others/themeController.dart';
import 'package:mioxi_frontend/others/sessionManager.dart';

class HomeDoctorEditDoctorPageScreen extends StatefulWidget {
  const HomeDoctorEditDoctorPageScreen({super.key});

  @override
  State<HomeDoctorEditDoctorPageScreen> createState() =>
      _HomeDoctorEditDoctorPageScreenState();
}

class _HomeDoctorEditDoctorPageScreenState
    extends State<HomeDoctorEditDoctorPageScreen> {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool _obscurePasswordDoctor = true.obs;


  UserDoctorModel? userDoctorModel;
  final UserDoctorController _userDoctorController = UserDoctorController();
  final UserDoctorServices userDoctorServices = UserDoctorServices();

  @override
  void initState() {
    super.initState();
    loadUserData();
    userDoctorServices.connectWS();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    final username = await SessionManager.getUsername("doctor");
    if (username != null) {
      final fetchedUser = await _userDoctorController.fetchUser("doctor");
      if (fetchedUser != null) {
        userDoctorModel = fetchedUser;
        name.value = userDoctorModel!.name;
        email.value = userDoctorModel!.email;
      }
    }
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    // 🎨 Colores dinámicos
    final appBarColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final buttonColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final textColor = isLight ? Colors.black87 : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Perfil doctor"),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(isLight ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
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
        if (userDoctorModel == null) {
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
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showChangePasswordDialog(context, textColor),
                  icon: const Icon(Icons.lock_reset, color: Colors.white),
                  label: const Text('Cambiar contraseña'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showChangePasswordDialog(BuildContext context, Color textColor) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Cambiar contraseña", style: TextStyle(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => TextField(
      controller: _userDoctorController.passwordPasswLostControllerDoctor,
      obscureText: _obscurePasswordDoctor.value,
      decoration: InputDecoration(
        labelText: "Nueva contraseña",
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePasswordDoctor.value ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => _obscurePasswordDoctor.value = !_obscurePasswordDoctor.value,
        ),
      ),
    )),
Obx(() => TextField(
      controller: _userDoctorController.confirmPasswordControllerDoctor,
      obscureText: _obscurePasswordDoctor.value,
      decoration: InputDecoration(
        labelText: "Confirmar contraseña",
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePasswordDoctor.value ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => _obscurePasswordDoctor.value = !_obscurePasswordDoctor.value,
        ),
      ),
    )),

          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: textColor)),
          ),
          ElevatedButton(
            onPressed: () {
              _userDoctorController.changeDoctorPassword();
              Navigator.pop(context);
            },
            child: Text('Guardar', style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? Colors.black87 : Colors.white;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          "¿Estás segura de que quieres cerrar sesión?",
          style: TextStyle(fontSize: 16, color: textColor, fontFamily: 'OpenSans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFE4E1)),
            child: const Text(
              "Cancelar",
              style: TextStyle(fontSize: 15, color: Color(0xFFB31B1B), fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _userDoctorController.logout();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB31B1B)),
            child: const Text(
              "Cerrar sesión",
              style: TextStyle(fontSize: 15, color: Color(0xFFFFE4E1), fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
