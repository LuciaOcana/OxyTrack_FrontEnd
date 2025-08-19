import 'package:get/get.dart';

class NavBarDoctorController extends GetxController {
  var selectedIndex = 0.obs;

  final List<String> routes = ['/doctorPatientListPage', '/doctorEditDoctorPage'];

  void navigateTo(int index) {
    selectedIndex.value = index;
    Get.offNamed(routes[index]);
  }
}
