import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/controller/bottom_navigation_controller.dart';

class MyBottomNavigationBar extends GetView<MyBottomNavigationBarController> {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MyBottomNavigationBarController controller = Get.put(MyBottomNavigationBarController());

    return Obx(() => Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                onTap: controller.changeIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.black,
                unselectedLabelStyle: const TextStyle(fontSize: 10),
                selectedLabelStyle: const TextStyle(fontSize: 10),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Column(
                        children: [
                          Icon(
                            Icons.menu_outlined,
                            color: controller.selectedIndex.value == 0 ? Colors.black : Colors.grey,
                            size: 30.0,
                            semanticLabel: 'Text to announce in accessibility modes',
                          ),
                        ],
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: Column(
                        children: [
                          Icon(
                            Icons.person_outlined,
                            color: controller.selectedIndex.value == 1 ? Colors.black : Colors.grey,
                            size: 30.0,
                            semanticLabel: 'Text to announce in accessibility modes',
                          ),
                        ],
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: Column(
                        children: [
                          Icon(
                            Icons.notifications_none_outlined,
                            color: controller.selectedIndex.value == 2 ? Colors.black : Colors.grey,
                            size: 30.0,
                            semanticLabel: 'Text to announce in accessibility modes',
                          ),
                        ],
                      ),
                      label: ""),
                ],
              )),
        ));
  }
}
