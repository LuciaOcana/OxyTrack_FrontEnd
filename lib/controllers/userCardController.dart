import 'package:get/get.dart';

class UserCardController extends GetxController {
  final RxBool hasNotification = false.obs;

  /// Activa la notificación visual durante 5 segundos
  void activateNotification() {
    hasNotification.value = true;
    Future.delayed(const Duration(seconds: 5), () {
      hasNotification.value = false;
    });
  }
}
