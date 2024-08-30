import 'package:brr/design_materials/design_materials.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/view/loading_circle/loading_circle.dart';
import 'package:brr/controller/join_match_controller.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:brr/controller/add_match_list_controller.dart';
import 'dart:convert';
class TaxiLoadingPageView extends StatelessWidget {
  const TaxiLoadingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.put(LocationController());
    final JoinMatchController controller = Get.put(JoinMatchController());
    final AddMatchListController controller_add = Get.put(AddMatchListController());
    return Obx(() {
      Map<String, dynamic>? parsedData;

      if (controller.currentMemberCount.value.contains('taxi_id')) {
        final message = controller.currentMemberCount.value;
        parsedData = jsonDecode(message);
      }
      else if (controller_add.currentMemberStatus.value.contains('taxi_id')) {
        final message = controller_add.currentMemberStatus.value;
        parsedData = jsonDecode(message);
      }

      if (parsedData != null) {
        final int taxiId = parsedData['taxi_id'];
        final String driverName = parsedData['driver_name'];
        final String carNum = parsedData['car_num'];
        final String phoneNumber = parsedData['phone_number'];
        final String depart = parsedData['depart'];
        final String dest = parsedData['dest'];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute != '/completematching') {
            Get.toNamed('/completematching', arguments: parsedData);
          }
        });
      }
      return Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BouncingDots(),
                  const SizedBox(height: 50),
                  const Text(
                    '수락을 대기 중이에요',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_taxi_outlined, color: Colors.blue, size: 50),
                      SizedBox(width: 8),
                      Icon(Icons.people_outline_outlined, color: Colors.blue, size: 50),
                    ],
                  ),
                ],
              ),
            ),
            // Positioned(top: 50.0, left: 30.0, child: gobackButton())
          ],
        ),
      );
    });
  }
}
