import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oxytrack_frontend/others/themeController.dart';
import 'package:get_storage/get_storage.dart';

// Pantallas principales del sistema
import 'package:oxytrack_frontend/screen/selectorModeScreen.dart';
import 'package:oxytrack_frontend/screen/logInScreen.dart';
import 'package:oxytrack_frontend/screen/logInDoctorScreen.dart';
import 'package:oxytrack_frontend/screen/logInAdminScreen.dart';

// Pantallas para cada rol
import 'package:oxytrack_frontend/screen/homePageScreen.dart';
import 'package:oxytrack_frontend/screen/profileUserScreen.dart';
import 'package:oxytrack_frontend/screen/homeDoctorPatientsListPageScreen.dart';
import 'package:oxytrack_frontend/screen/homeDoctorEditDoctorPageScreen.dart';
import 'package:oxytrack_frontend/screen/homeAdminDoctorListPageScreen.dart';
import 'package:oxytrack_frontend/screen/homeAdminAddDoctorPageScreen.dart';
import 'package:oxytrack_frontend/screen/homeGuestPageScreen.dart';

// Otros widgets o pantallas compartidas
import 'package:oxytrack_frontend/widgets/navBarUser.dart';
import 'package:oxytrack_frontend/widgets/navBarAdmin.dart';
import 'package:oxytrack_frontend/widgets/navBarDoctor.dart';

import 'package:oxytrack_frontend/services/backendService.dart';
import 'package:oxytrack_frontend/ble/bleListener.dart'; // Tu BLE listener
import 'package:oxytrack_frontend/ble/blePermissions.dart';

//final BleListener _bleListener = BleListener();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // ✅ Inicializa GetStorage
  Get.put(ThemeController());

  await requestBLEPermissions();  // 🔹 Pedimos permisos al inicio

// Iniciar escaneo y conexión automática
  

  // 🔹 Iniciar escaneo y conexión automática
  //await _bleListener.scanAndConnect();

  final initialRoute = await getInitialRoute();
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();

      return GetMaterialApp(
        title: 'OxyTrack',
        debugShowCheckedModeBanner: false,

        // Tema claro personalizado
        theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFE0F7FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF89AFAF),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black54),
            titleLarge: TextStyle(color: Colors.black),
          ),
        ),

        // Tema oscuro personalizado
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[850],
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(color: Colors.white),
          ),
          buttonTheme: ButtonThemeData(buttonColor: Colors.grey[700]),
          iconTheme: const IconThemeData(color: Colors.white70),
        ),

        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        initialRoute: initialRoute,
        getPages: [
          // General
          GetPage(name: '/selectorMode', page: () => SelectorModeScreen()),

          // Usuario
          GetPage(name: '/logIn', page: () => logInScreen()),
          GetPage(
            name: '/homeUser',
            page: () => BottomNavScaffold(child: HomePageScreen()),
          ),
          GetPage(
            name: '/profileUser',
            page: () => BottomNavScaffold(child: UserProfileScreen()),
          ),

          // Ucuario invitado
          GetPage(name: '/homeGuest', page: () => HomeGuestPageScreen()),

          // Doctor
          GetPage(name: '/loginDoctor', page: () => LogInDoctorScreen()),
          GetPage(
            name: '/doctorPatientListPage',
            page:
                () => BottomNavScaffoldDoctor(
                  child: HomeDoctorPatientListPageScreen(),
                ),
          ),
          GetPage(
            name: '/doctorEditDoctorPage',
            page:
                () => BottomNavScaffoldDoctor(
                  child: HomeDoctorEditDoctorPageScreen(),
                ),
          ),

          // Admin
          GetPage(name: '/loginAdmin', page: () => LogInAdminScreen()),
          GetPage(
            name: '/adminDoctorListPage',
            page:
                () =>
                    BottomNavScaffoldAdmin(child: AdminDoctorListPageScreen()),
          ),
          GetPage(
            name: '/adminAddDoctorPage',
            page:
                () => BottomNavScaffoldAdmin(child: AdminAddDoctorPageScreen()),
          ),
        ],
      );
    });
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
      return '/adminDoctorListPage';
    default:
      return '/selectorMode';
  }
}
