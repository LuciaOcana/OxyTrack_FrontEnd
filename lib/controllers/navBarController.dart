import 'package:get/get.dart';

class NavBarController extends GetxController {
  var selectedIndex = 0.obs;

  final List<String> routes = ['/home', '/perfil'];

  void navigateTo(int index) {
    selectedIndex.value = index;
    Get.offNamed(routes[index]);
  }
}
