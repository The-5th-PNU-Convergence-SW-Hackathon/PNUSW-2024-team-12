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
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();

  final LocationController locationController = Get.put(LocationController());

  Future<void> _saveLocations() async {
    String startLocation = startLocationController.text.trim();
    String endLocation = endLocationController.text.trim();

    if (startLocation.isEmpty || endLocation.isEmpty) {

      Get.snackbar(
        "입력 오류",
        "출발지와 도착지를 모두 입력해주세요.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }


    bool success = await locationController.setLocations(startLocation, endLocation);

    if (success) {

      Get.back(result: true);
    } else {
      Get.snackbar(
        "경로 계산 실패",
        "출발지 또는 도착지의 좌표를 찾을 수 없거나 경로 계산에 실패했습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
              Container(
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
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                      ),
                    ),
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
