import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/userAdminController.dart';
import '../controllers/userListController.dart';
import '../models/user.dart';
import '../widgets/userCard.dart';
import '../services/userDoctorServices.dart';
import '../others/sessionManager.dart';

class HomeDoctorPatientListPageScreen extends StatefulWidget {
  const HomeDoctorPatientListPageScreen({super.key});

  @override
  State<HomeDoctorPatientListPageScreen> createState() =>
      _HomeDoctorPatientListPageScreenState();
}

class _HomeDoctorPatientListPageScreenState
    extends State<HomeDoctorPatientListPageScreen> {
  final UserAdminController _userAdminController = UserAdminController();
  final UserListController _userListController = Get.put(UserListController());

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de usuarios'),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'prev',
                  onPressed: _userListController.currentPage.value > 1
                      ? _userListController.previousPage
                      : null,
                  backgroundColor: _userListController.currentPage.value > 1
                      ? const Color(0xFF0096C7)
                      : Colors.grey,
                  child: const Icon(Icons.arrow_back),
                  tooltip: 'Página anterior',
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'refresh',
                  onPressed: _userListController.fetchUsers,
                  backgroundColor: const Color(0xFF0096C7),
                  child: _userListController.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : const Icon(Icons.refresh),
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
                          ? const Color(0xFF0096C7)
                          : Colors.grey,
                  child: const Icon(Icons.arrow_forward),
                  tooltip: 'Página siguiente',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Text(
            "¿Estás segura de que quieres cerrar sesión?",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 0, 0, 0),
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
                _userAdminController.logout();
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
