import 'package:get/get.dart';

class MyBottomNavigationBarController extends GetxController {
  static MyBottomNavigationBarController get to => Get.find();

  final RxInt selectedIndex = 1.obs;

  void changeIndex(int index) {
    selectedIndex(index);
    switch (index) {
      case 0:
        Get.toNamed('/matchlist');
        break;
      case 1:
        Get.toNamed('/');
        break;
      case 2:
        Get.toNamed('/mypage');
        break;
    }
  }
}
