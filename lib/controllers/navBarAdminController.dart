import 'package:get/get.dart';

class NavBarAdminController extends GetxController {
  var selectedIndex = 0.obs;

  final List<String> routes = ['/adminDoctorListPage', '/adminAddDoctorPage'];

  void navigateTo(int index) {
    selectedIndex.value = index;
    Get.offNamed(routes[index]);
  }
}
