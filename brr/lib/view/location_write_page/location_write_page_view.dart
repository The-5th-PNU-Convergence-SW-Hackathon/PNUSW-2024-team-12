import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class WriteLocationPageView extends StatefulWidget {
  const WriteLocationPageView({super.key});

  @override
  _WriteLocationPageViewState createState() => _WriteLocationPageViewState();
}

class _WriteLocationPageViewState extends State<WriteLocationPageView> {
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();

  final LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    startLocationController.text = locationController.startLocation.value;
    endLocationController.text = locationController.endLocation.value;
  }

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
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1479FF),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
    '위치 설정',
    style: TextStyle(color: Colors.black),
  ),
  centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.check, color: Color(0xFF1479FF),),
              onPressed: _saveLocations,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0XFFE6F0FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        circleContainer,
                        const SizedBox(width: 10),
                        const Text(
                          '출발지 : ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF676767),
                          ),
                        ),
                      ],
                    ),
                    
                    Expanded(
                      child: TextField(
                        controller: startLocationController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '출발지 입력',
                          hintStyle: TextStyle(
                            color: Color(0xFF676767),),
                        
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0XFFE6F0FF),
                  borderRadius: BorderRadius.circular(15),),
                child: Row(
                  children: [
                    Row(
                      children: [
                        rectangularContainer,
                        const SizedBox(width: 10),
                        const Text(
                          '도착지 : ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF676767),
                            
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TextField(
                        controller: endLocationController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '도착지 입력',
                          hintStyle: TextStyle(
                            color: Color(0xFF676767),),
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
