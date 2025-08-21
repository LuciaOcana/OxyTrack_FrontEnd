import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:oxytrack_frontend/models/user.dart';
import 'package:oxytrack_frontend/services/userServices.dart';
import 'package:oxytrack_frontend/services/userDoctorServices.dart';


class UserListController extends GetxController {
  final isLoading = false.obs;
  final userList = <UserModel>[].obs;
  final currentPage = 1.obs;
  final limit = 10.obs;

  final UserServices userService = UserServices();
    final UserDoctorServices userDoctorService = UserDoctorServices();
  final RxMap<String, bool> userNotifications = <String, bool>{}.obs;


   @override
  void onInit() {
    super.onInit();
  }




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

  void setLimit(int newLimit) {
    if (limit.value != newLimit) {
      limit.value = newLimit;
      currentPage.value = 1;
      fetchUsers();
    }
  }

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
