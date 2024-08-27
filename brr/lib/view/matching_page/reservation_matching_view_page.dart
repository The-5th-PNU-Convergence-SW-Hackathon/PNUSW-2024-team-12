import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:brr/controller/add_match_list_controller.dart';

class ReservationMatchingPageView extends StatelessWidget {
  const ReservationMatchingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.put(LocationController());

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.blueGrey,
            child: const Center(
              child: Image(
                image: AssetImage('assets/images/map.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.12,
            maxChildSize: 0.55,
            builder: (context, scrollController) {
              return Container(
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                              ),
                              const SizedBox(height: 15),
                              const Text('택시를 호출할 시간을 설정해주세요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 15),
                              
                            ],
                          )),
                    ],
                  ));
            }),
        Positioned(
          top: 50.0,
          left: 30.0,
          child: Row(
            children: [
              gobackButton(),
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/writelocation');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.1),
                ),
                child: SizedBox(
                  width: 270.0,
                  height: 70,
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          locationRow(circleContainer, '출발지', locationController.startLocation.value.isEmpty ? '' : locationController.startLocation.value),
                          const SizedBox(height: 5.0),
                          locationRow(rectangularContainer, '도착지', locationController.endLocation.value.isEmpty ? '' : locationController.endLocation.value),
                        ],
                      )),
                ),
              )
            ],
          ),
        )
      ],
    )));
  }

  Widget locationRow(Widget icon, String title, String subtitle) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 10.0),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 5.0),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
