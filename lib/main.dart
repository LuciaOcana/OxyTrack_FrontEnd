import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxytrack_frontend/screen/selectorModeScreen.dart';
import 'package:oxytrack_frontend/screen/homePageScreen.dart';
import 'package:oxytrack_frontend/screen/logInScreen.dart';
import 'package:oxytrack_frontend/screen/logInDoctorScreen.dart';
import 'package:oxytrack_frontend/screen/logInAdminScreen.dart';
import 'package:oxytrack_frontend/screen/adminPageScreen.dart';

import 'package:oxytrack_frontend/screen/bluetoothScreen.dart';



void main() {
  //runApp(const MyApp());
    runApp(MyApp());

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
      initialRoute: '/selectorMode',//'/home',
      getPages: [
        // Ruta de inicio de sesión
        GetPage(
          name: '/selectorMode',
          page: () => SelectorModeScreen(),
        ),
        GetPage(
          name: '/home',
          page: () => homePageScreen(),
        ),
        GetPage(
          name: '/bluetooth',
          page: () => BluetoothPage(), // ← Nueva ruta
        ),
        GetPage(
          name: '/logIn',
          page: () => logInScreen(), // ← Nueva ruta
        ),
        GetPage(
         name: '/loginDoctor',
         page: () => LogInDoctorScreen(), // ← Nueva ruta
        ),
        GetPage(
         name: '/loginAdmin',
         page: () => LogInAdminScreen(), // ← Nueva ruta
        ),
        GetPage(
         name: '/adminPage',
         page: () => AdminPageScreen(), // ← Nueva ruta
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
