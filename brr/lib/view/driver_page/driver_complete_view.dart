import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/driver_call_controller.dart';
import 'package:get/get.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

class DriverCompletePageView extends StatelessWidget {
  final int matchingId;
  final int fare;

  DriverCompletePageView(
      {super.key, required this.matchingId, required this.fare});

  final DriverAcceptController driverAcceptController =
      Get.put(DriverAcceptController());

  @override
  Widget build(BuildContext context) {
    driverAcceptController.fetchCallInfo(matchingId);
    driverAcceptController.completeCall(matchingId, fare);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          titleSpacing: 25.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 왼쪽에 로고와 텍스트 "기사앱"
              Row(
                children: [
                  brrLogo(), // 로고 위젯
                  const SizedBox(width: 22),
                  const Text(
                    '기사앱',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              TimerBuilder.periodic(const Duration(seconds: 1),
                  builder: (context) {
                return Text(
                  DateFormat('yyyy. M. d. h:mm:ss').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                );
              }),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() {
              if (driverAcceptController.callInfo.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var callInfo = driverAcceptController.callInfo;
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F8FF),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFFE2EAF5), width: 2),
                              ),
                              width: double.infinity,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      callInfo['depart'],
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true, // 줄바꿈을 허용
                                    ),
                                    CustomPaint(
                                      size: const Size(40, 40),
                                      painter: ArrowPainter(),
                                    ),
                                    Text(
                                      callInfo['dest'],
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true, // 줄바꿈을 허용
                                      overflow: TextOverflow
                                          .ellipsis, // 텍스트가 너무 길 경우 말줄임표 추가
                                      maxLines: 2, // 최대 2줄까지만 표시
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("총 운행 요금",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text('${fare.toString()}원',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 70,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.toNamed('/drivermain');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1479FF),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  '콜 리스트 돌아가기',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ));
              }
            }),
            const SizedBox(height: 60),
          ],
        ));
  }

  Widget detailInfo(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 15, color: Colors.black)),
        Text(text,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.25);
    path.lineTo(size.width * 0.5, size.height * 0.5);
    path.lineTo(size.width * 0.75, size.height * 0.25);

    path.moveTo(size.width * 0.25, size.height * 0.5);
    path.lineTo(size.width * 0.5, size.height * 0.75);
    path.lineTo(size.width * 0.75, size.height * 0.5);

    path.moveTo(size.width * 0.25, size.height * 0.75);
    path.lineTo(size.width * 0.5, size.height * 1.0);
    path.lineTo(size.width * 0.75, size.height * 0.75);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
