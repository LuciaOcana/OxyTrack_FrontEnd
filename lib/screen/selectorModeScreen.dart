import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/others/themeController.dart';

class SelectorModeScreen extends StatelessWidget {
  const SelectorModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Si el tema es claro, fondo blanco. Si es oscuro, fondo del tema.
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0096C7),
        centerTitle: true,
        automaticallyImplyLeading: false,
        // 🌙/☀️ Botón de cambiar tema
        leading: IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.light
                ? Icons
                    .dark_mode // si está claro → mostrar luna
                : Icons.light_mode, // si está oscuro → mostrar sol
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
                  Theme.of(context).brightness == Brightness.light
                      ? 'lib/others/images/SpO.png' // 🟢 Imagen para tema claro
                      : 'lib/others/images/SpODark.png', // 🌑 Imagen para tema oscuro
                  height: 200,
                ),

                const SizedBox(height: 20),
                const Text(
                  'Bienvenido a OxyTrack',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF0096C7),
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
                    backgroundColor: const Color(0xFF0096C7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed('/logIn');
                  },
                  child: const Text(
                    'Soy paciente',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFCAF0F8),
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
                    backgroundColor: const Color(0xFF0096C7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed('/loginDoctor');
                  },
                  child: const Text(
                    'Soy personal médico',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFCAF0F8),
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
