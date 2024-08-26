import 'package:get/get.dart';

class DriverBottomNavigationBarController extends GetxController {
  static DriverBottomNavigationBarController get to => Get.find();

  final RxInt selectedIndex = 1.obs;

  void changeIndex(int index) {
    selectedIndex(index);
    switch (index) {
      case 0:
        Get.toNamed('/matchlist');
        break;
      case 1:
        Get.toNamed('/drivermain');
        break;
      case 2:
        Get.toNamed('/drivermain');
        break;
    }
  }
}
