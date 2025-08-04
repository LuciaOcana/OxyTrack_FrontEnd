import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pantallas principales del sistema
import 'package:oxytrack_frontend/screen/selectorModeScreen.dart';
import 'package:oxytrack_frontend/screen/logInScreen.dart';
import 'package:oxytrack_frontend/screen/logInDoctorScreen.dart';
import 'package:oxytrack_frontend/screen/logInAdminScreen.dart';

// Pantallas para cada rol
import 'package:oxytrack_frontend/screen/homePageScreen.dart';
import 'package:oxytrack_frontend/screen/profileUserScreen.dart';
import 'package:oxytrack_frontend/screen/homeDoctorPageScreen.dart';
import 'package:oxytrack_frontend/screen/homaAdminPageScreen.dart';

// Otros widgets o pantallas compartidas
import 'package:oxytrack_frontend/screen/bluetoothScreen.dart';
import 'package:oxytrack_frontend/widgets/navBarUser.dart';

void main() async {
  // Asegura que los plugins como SharedPreferences estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Obtiene la ruta inicial según el rol guardado (user, doctor, admin)
  final initialRoute = await getInitialRoute();

  // Inicia la app
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OxyTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: [
        // General / Selección
        GetPage(name: '/selectorMode', page: () => SelectorModeScreen()),

        // Usuario
        GetPage(name: '/logIn', page: () => logInScreen()),
        GetPage(
          name: '/homeUser',
          page: () => BottomNavScaffold(child: homePageScreen()),
        ),
        GetPage(
          name: '/profileUser',
          page: () => BottomNavScaffold(child: UserProfileScreen()),
        ),

        // Doctor
        GetPage(name: '/loginDoctor', page: () => LogInDoctorScreen()),
        GetPage(name: '/homeDoctor', page: () => HomeDoctorPageScreen()),

        // Admin
        GetPage(name: '/loginAdmin', page: () => LogInAdminScreen()),
        GetPage(name: '/adminPage', page: () => AdminPageScreen()),

        // Común
        GetPage(name: '/bluetooth', page: () => BluetoothPage()),
      ],
    );
  }
}

/// Verifica si hay sesión guardada y redirige según el rol
Future<String> getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final role = prefs.getString('user_role');

  switch (role) {
    case 'user':
      return '/homeUser';
    case 'doctor':
      return '/homeDoctor';
    case 'admin':
      return '/adminPage';
    default:
      return '/selectorMode'; // Si no hay sesión, vuelve al selector
  }
}
