import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/screen/homePageScreen.dart';
import 'package:oxytrack_frontend/screen/logInScreen.dart'; // Asegúrate de que esta importación sea correcta.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Login de Usuario',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // Definir las rutas de navegación de forma clara
      initialRoute: '/home',
      getPages: [
        // Ruta de inicio de sesión
        GetPage(
          name: '/home',
          page: () => homePageScreen(),
        ),
        // Si tienes más pantallas, agrégalas aquí
        // GetPage(
        //   name: '/login',
        //   page: () => LogInScreen(),
        // ),
      ],
    );
  }
}
