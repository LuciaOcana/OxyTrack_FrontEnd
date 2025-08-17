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
import 'package:oxytrack_frontend/screen/homaAdminDoctorListPageScreen.dart';
import 'package:oxytrack_frontend/screen/homaAdminAddDoctorPageScreen.dart';

// Otros widgets o pantallas compartidas
import 'package:oxytrack_frontend/screen/bluetoothScreen.dart';
import 'package:oxytrack_frontend/widgets/navBarUser.dart';
import 'package:oxytrack_frontend/widgets/navBarAdmin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialRoute = await getInitialRoute();

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
        // General
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
        GetPage(
          name: '/adminDoctorListPage',
          page: () => BottomNavScaffoldAdmin(child: AdminDoctorListPageScreen()),
        ),
        GetPage(
          name: '/adminAddDoctorPage',
          page: () => BottomNavScaffoldAdmin(child: AdminAddDoctorPageScreen()),
        ),

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
      return '/adminDoctorListPage'; // 🔹 Corrijo esta ruta
    default:
      return '/selectorMode'; // Si no hay sesión → selección
  }
}
