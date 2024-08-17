import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:get/get.dart';

class WriteLocationPageView extends StatefulWidget {
  const WriteLocationPageView({super.key});

  @override
  _WriteLocationPageViewState createState() => _WriteLocationPageViewState();
}

class _WriteLocationPageViewState extends State<WriteLocationPageView> {
  bool isEditingStartLocation = false;
  bool isEditingEndLocation = false;
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();

  final LocationController locationController = Get.put(LocationController());

  void _toggleStartLocationEdit() {
    setState(() {
      if (isEditingEndLocation) {
        // 도착지 수정 중이면 도착지 수정 종료
        locationController.updateEndLocation(endLocationController.text);
        isEditingEndLocation = false;
      }
      isEditingStartLocation = true;
      startLocationController.text = locationController.startLocation.value;
    });
  }

  void _toggleEndLocationEdit() {
    setState(() {
      if (isEditingStartLocation) {
        // 출발지 수정 중이면 출발지 수정 종료
        locationController.updateStartLocation(startLocationController.text);
        isEditingStartLocation = false;
      }
      isEditingEndLocation = true;
      endLocationController.text = locationController.endLocation.value;
    });
  }

  void _saveLocations() {
    setState(() {
      if (isEditingStartLocation) {
        locationController.updateStartLocation(startLocationController.text);
        isEditingStartLocation = false;
      }
      if (isEditingEndLocation) {
        locationController.updateEndLocation(endLocationController.text);
        isEditingEndLocation = false;
      }
      FocusScope.of(context).unfocus();
      Get.toNamed('/matching');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _saveLocations,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.blue),
              onPressed: _saveLocations,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              isEditingStartLocation
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          circleContainer,
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: startLocationController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '출발지를 입력해주세요',
                              ),
                              onSubmitted: (value) => _saveLocations(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : TextButton(
                      onPressed: _toggleStartLocationEdit,
                      child: Row(
                        children: [
                          circleContainer,
                          const SizedBox(width: 10),
                          Obx(() => Text(
                                '출발지 : ${locationController.startLocation.value}',
                                style: const TextStyle(fontSize: 20, color: Colors.black),
                              )),
                        ],
                      ),
                    ),
              const SizedBox(height: 20),
              isEditingEndLocation
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          rectangularContainer,
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: endLocationController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '도착지를 입력해주세요',
                              ),
                              onSubmitted: (value) => _saveLocations(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : TextButton(
                      onPressed: _toggleEndLocationEdit,
                      child: Row(
                        children: [
                          rectangularContainer,
                          const SizedBox(width: 10),
                          Obx(() => Text(
                                '도착지 : ${locationController.endLocation.value}',
                                style: const TextStyle(fontSize: 20, color: Colors.black),
                              )),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
