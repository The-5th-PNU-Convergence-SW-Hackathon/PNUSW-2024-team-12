import 'package:brr/design_materials/design_materials.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/view/loading_circle/loading_circle.dart';
import 'package:brr/controller/join_match_controller.dart';

class JoinMatchLoadingPageView extends StatelessWidget {
  const JoinMatchLoadingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final JoinMatchController controller = Get.find<JoinMatchController>();
    return Obx(() {

      if (controller.currentMemberCount.value == '매칭이 시작되었습니다.') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/taxiloading');  
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
                  '매칭을 시도하는 중이에요',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '현재 인원: ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Obx(() => Text(
                          controller.currentMemberCount.value.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        )),
                    const Text(
                      "/4 모집중",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  '현재 인원으로 출발하기를 원하시면\n아래의 출발해요 버튼을 눌러주세요',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
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
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          controller.disconnectFromLobby();
                          Get.back(); // 페이지 뒤로가기
                        },
                        child: const Text(
                          '매칭 나가기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(top: 50.0, left: 30.0, child: gobackButton())
        ],
      ),
    );
  });
  }
}
