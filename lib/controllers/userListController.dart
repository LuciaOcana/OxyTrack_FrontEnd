// ======================================================
// UserListController: Controlador para lista de usuarios
// Maneja: Fetch de usuarios, paginación y notificaciones
// ======================================================

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mioxi_frontend/models/user.dart';
import 'package:mioxi_frontend/services/userServices.dart';
import 'package:mioxi_frontend/services/userDoctorServices.dart';
import 'package:mioxi_frontend/others/sessionManager.dart';

class UserListController extends GetxController {
  // ------------------------------
  // Variables reactivas
  // ------------------------------
  final isLoading = false.obs;
  final userList = <UserModel>[].obs;
  final currentPage = 1.obs;
  final limit = 10.obs;

  // ------------------------------
  // Servicios
  // ------------------------------
  final UserServices userService = UserServices();
  final UserDoctorServices userDoctorService = UserDoctorServices();

  // ------------------------------
  // Notificaciones por usuario
  // ------------------------------
  final Map<String, RxBool> userNotifications = {};

  // ------------------------------
  // Inicialización
  // ------------------------------
  @override
  void onInit() {
    super.onInit();
    _connectToNotifications();
  }

  // ======================================================
  // Conexión al WebSocket y escucha de notificaciones
  // ======================================================
  void _connectToNotifications() {
    userDoctorService.connectWS();

    userDoctorService.notificationsStream.listen((msg) {
      final patientUsername = msg["patient"]?.toString().trim();
      final targetDoctor = msg["target"]?.toString().trim();
      final currentDoctor = SessionManager.doctorUsername?.trim();

      if (patientUsername != null && targetDoctor == currentDoctor) {
        activateNotificationFor(patientUsername);
      }
    });
  }

  // ======================================================
  // Activar notificación visual para un usuario
  // ======================================================
  void activateNotificationFor(String username) {
    print("🔔 Activando notificación para $username");
    if (!userNotifications.containsKey(username)) {
      userNotifications[username] = false.obs;
    }
    userNotifications[username]!.value = true;
  }

  // ======================================================
  // Obtener usuarios desde el servicio
  // ======================================================
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final users = await userDoctorService.getUsers(
        page: currentPage.value,
        limit: limit.value,
      );
      userList.assignAll(users ?? []);
    } catch (e, stackTrace) {
      debugPrint("❌ Error fetching users: $e\n$stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // Cambiar límite de usuarios por página
  // ======================================================
  void setLimit(int newLimit) {
    if (limit.value != newLimit) {
      limit.value = newLimit;
      currentPage.value = 1;
      fetchUsers();
    }
  }

  // ======================================================
  // Paginación
  // ======================================================
  void nextPage() {
    currentPage.value++;
    fetchUsers();
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchUsers();
    }
  }
}
