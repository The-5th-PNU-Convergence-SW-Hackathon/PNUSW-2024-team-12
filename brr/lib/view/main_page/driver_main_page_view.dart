import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/constants/bottom_navigation/bottom_navigation_controller.dart';
import 'package:brr/design_materials/design_materials.dart';

class DriverMainPageView extends StatefulWidget {
  DriverMainPageView({super.key});

  final _bottomNavController = Get.put(MyBottomNavigationBarController());

  @override
  State<DriverMainPageView> createState() => _DriverMainPageViewState();
}

class _DriverMainPageViewState extends State<DriverMainPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        titleSpacing: 25.0,
        title: Row(
          children: [
            brrLogo(),
            const SizedBox( width: 22 ),
            const Text( '기사앱', style: TextStyle( fontSize: 12, fontWeight: FontWeight.bold ) )
          ],
        )
      ),
    );
  }
}
