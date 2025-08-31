import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mioxi_frontend/models/userDoctor.dart';
import 'package:mioxi_frontend/services/userDoctorServices.dart';

import 'package:mioxi_frontend/services/userAdminServices.dart';

class DoctorListController extends GetxController {
  final isLoading = false.obs;
  final doctorList = <UserDoctorModel>[].obs;
  final currentPage = 1.obs;
  final limit = 10.obs;

  final UserDoctorServices userDoctorService = UserDoctorServices();
  final UserAdminServices userAdminService = UserAdminServices();

  /*@override
  void onInit() {
    super.onInit();
    fetchDoctors(); // Llamada inicial
  }*/

  Future<void> fetchDoctors() async {
    try {
      isLoading.value = true;
      final doctors = await userAdminService.getDoctors(
        page: currentPage.value,
        limit: limit.value,
      );
      doctorList.assignAll(doctors ?? []);
      debugPrint("✅ Doctors fetched: ${doctors?.length}");

    } catch (e, stackTrace) {
      debugPrint("❌ Error fetching doctor: $e\n$stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  void setLimit(int newLimit) {
    if (limit.value != newLimit) {
      limit.value = newLimit;
      currentPage.value = 1;
      fetchDoctors();
    }
  }

  void nextPage() {
    currentPage.value++;
    fetchDoctors();
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchDoctors();
    }
  }
}
