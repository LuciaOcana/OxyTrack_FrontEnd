import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/others/themeController.dart';

class SelectorModeScreen extends StatelessWidget {
  const SelectorModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    // 🎨 Paleta dinámica
    final appBarColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final buttonColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final buttonTextColor = isLight ? Colors.white : const Color(0xFFCAF0F8);
    final titleColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final textPrimary = isLight ? Colors.black87 : Colors.white;

    return Scaffold(
      backgroundColor: isLight ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            isLight ? Icons.dark_mode : Icons.light_mode,
            color: Colors.white,
          ),
          onPressed: () => Get.find<ThemeController>().toggleTheme(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed('/loginAdmin');
            },
            child: const Text(
              'Administrador',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  isLight
                      ? 'lib/others/images/SpO.png'
                      : 'lib/others/images/SpODark.png',
                  height: 200,
                ),

                const SizedBox(height: 20),
                Text(
                  'Bienvenido a OxyTrack',
                  style: TextStyle(
                    fontSize: 24,
                    color: titleColor,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // 🔵 Botón Soy paciente
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed('/logIn');
                  },
                  child: Text(
                    'Soy paciente',
                    style: TextStyle(
                      fontSize: 18,
                      color: buttonTextColor,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🩺 Botón Soy personal médico
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed('/loginDoctor');
                  },
                  child: Text(
                    'Soy personal médico',
                    style: TextStyle(
                      fontSize: 18,
                      color: buttonTextColor,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Este texto también cambia con el tema',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
