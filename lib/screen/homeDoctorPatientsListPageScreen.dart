import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/userListController.dart';
import '../models/user.dart';
import '../widgets/userCard.dart';
import '../services/userDoctorServices.dart';
import '../others/sessionManager.dart';
import 'package:oxytrack_frontend/others/themeController.dart';
import '../controllers/userDoctorController.dart';


class HomeDoctorPatientListPageScreen extends StatefulWidget {
  const HomeDoctorPatientListPageScreen({super.key});

  @override
  State<HomeDoctorPatientListPageScreen> createState() =>
      _HomeDoctorPatientListPageScreenState();
}

class _HomeDoctorPatientListPageScreenState
    extends State<HomeDoctorPatientListPageScreen> {
  final UserListController _userListController = Get.put(UserListController());
  final UserDoctorController _userDoctorController = UserDoctorController();


  @override
  void initState() {
    super.initState();
    _userListController.fetchUsers();

    final userDoctorServices = UserDoctorServices();
    userDoctorServices.connectWS();

    userDoctorServices.notificationsStream.listen((msg) {
        print("📩 Mensaje recibido: $msg");
      final patientUsername = msg["patient"]?.toString().trim();
      final targetDoctor = msg["target"]?.toString().trim();
      final currentDoctor = SessionManager.doctorUsername?.trim();

      if (patientUsername != null && targetDoctor == currentDoctor) {
        _userListController.activateNotificationFor(patientUsername);
      }
    });
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


    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de usuarios'),
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
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Obx(() {
              if (_userListController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_userListController.userList.isEmpty) {
                return const Center(
                  child: Text('No hay usuarios disponibles.'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _userListController.userList.length,
                itemBuilder: (context, index) {
                  final user = _userListController.userList[index];
                  final hasNotif = _userListController
                          .userNotifications[user.username] ??
                      false.obs;

                  return UserCard(
                    user: user,
                    hasNotification: hasNotif,
                    onEdit: () => _userListController.fetchUsers(),
                  );
                },
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
             child: SizedBox(
              width: double.infinity, // 👈 fuerza el Row a ocupar todo el ancho
            child: Row(
 mainAxisAlignment:
                    MainAxisAlignment.center, // 👈 centra el contenido
                                  children: [
                FloatingActionButton(
                  heroTag: 'prev',
                  onPressed: _userListController.currentPage.value > 1
                      ? _userListController.previousPage
                      : null,
                  backgroundColor: _userListController.currentPage.value > 1
                      ? buttonColor
                      : (isLight ? Colors.grey[500]! : Colors.grey[700]!),
child: Icon(
                      Icons.arrow_back,
                      color:
                          isLight
                              ? Colors.white
                              : Colors.white, // 👈 aquí eliges el color
                    ),                  tooltip: 'Página anterior',
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'refresh',
                  onPressed: _userListController.fetchUsers,
                  backgroundColor: buttonColor,
                  child: _userListController.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : Icon(
                              Icons.refresh,
                              color:
                                  isLight
                                      ? Colors.white
                                      : Colors.white, // 👈 aquí eliges el color
                            ),
                  tooltip: 'Recargar lista',
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'next',
                  onPressed: _userListController.userList.length ==
                          _userListController.limit.value
                      ? _userListController.nextPage
                      : null,
                  backgroundColor:
                      _userListController.userList.length ==
                              _userListController.limit.value
                          ? buttonColor
                          : (isLight ? Colors.grey[500]! : Colors.grey[700]!),
                   child: Icon(
                      Icons.arrow_forward,
                      color:
                          isLight
                              ? Colors.white
                              : Colors.white, // 👈 aquí eliges el color
                    ),
                  tooltip: 'Página siguiente',
                ),
              ],
            ),
          ),
        ),
      ),
       ),
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
                _userDoctorController.logout();
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
