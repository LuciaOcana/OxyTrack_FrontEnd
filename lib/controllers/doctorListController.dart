// ------------------------------------------------------------
// DoctorListController: Gestión de la lista de doctores
// ------------------------------------------------------------
// Funciones principales:
// - Cargar lista de doctores con paginación
// - Control de estado de carga (loading)
// - Cambiar página y límite de elementos
// ------------------------------------------------------------

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mioxi_frontend/models/userDoctor.dart';
import 'package:mioxi_frontend/services/userDoctorServices.dart';
import 'package:mioxi_frontend/services/userAdminServices.dart';

class DoctorListController extends GetxController {
  // ------------------------------
  // Estado observable
  // ------------------------------
  final isLoading = false.obs;           // Indica si se está cargando la lista
  final doctorList = <UserDoctorModel>[].obs; // Lista de doctores
  final currentPage = 1.obs;             // Página actual de la lista
  final limit = 10.obs;                  // Límite de doctores por página

  // ------------------------------
  // Servicios para interacción con la API
  // ------------------------------
  final UserDoctorServices userDoctorService = UserDoctorServices();
  final UserAdminServices userAdminService = UserAdminServices();

  // ------------------------------------------------------------
  // Función principal: obtiene la lista de doctores desde la API
  // ------------------------------------------------------------
  Future<void> fetchDoctors() async {
    try {
      isLoading.value = true; // Indica que inicia la carga

      final doctors = await userAdminService.getDoctors(
        page: currentPage.value,
        limit: limit.value,
      );

      doctorList.assignAll(doctors ?? []); // Actualiza la lista observable
      debugPrint("✅ Doctors fetched: ${doctors?.length}");
    } catch (e, stackTrace) {
      debugPrint("❌ Error fetching doctors: $e\n$stackTrace");
    } finally {
      isLoading.value = false; // Finaliza la carga
    }
  }

  // ------------------------------------------------------------
  // Cambiar el límite de doctores por página
  // ------------------------------------------------------------
  void setLimit(int newLimit) {
    if (limit.value != newLimit) {
      limit.value = newLimit;
      currentPage.value = 1; // Reinicia la página
      fetchDoctors();         // Refresca la lista
    }
  }

  // ------------------------------------------------------------
  // Pasar a la siguiente página
  // ------------------------------------------------------------
  void nextPage() {
    currentPage.value++;
    fetchDoctors();
  }

  // ------------------------------------------------------------
  // Retroceder a la página anterior
  // ------------------------------------------------------------
  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchDoctors();
    }
  }
}
