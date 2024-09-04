import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/driver_call_controller.dart';
import 'package:get/get.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

class DriverDecideNavigationPageView extends StatelessWidget {
  final int matchingId;

  DriverDecideNavigationPageView({super.key, required this.matchingId});

  final DriverAcceptController driverAcceptController =
      Get.put(DriverAcceptController());
  final TextEditingController fareController =
      TextEditingController(); // 금액 입력 컨트롤러 추가

  @override
  Widget build(BuildContext context) {
    driverAcceptController.fetchCallInfo(matchingId);

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
        body: Obx(() {
          if (driverAcceptController.callInfo.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var callInfo = driverAcceptController.callInfo;
            fareController.text = '${callInfo['taxi_fare']}';

            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    locationInfo('출발', callInfo['depart'], '현재 위치에서 3km'),
                    CustomPaint(
                      size: const Size(40, 40),
                      painter: ArrowPainter(),
                    ),
                    locationInfo('도착', callInfo['dest'], ''),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        detailInfo('예상요금/거리',
                            '${callInfo['taxi_fare']}원/${callInfo['distance']}km'),
                        detailInfo('소요시간', '${callInfo['duration']}분'),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        text_Button('길안내', 'drivermain'),
                        const SizedBox(height: 20),
                        text_Button('운행 완료', '', context), // context를 넘기도록 수정
                      ],
                    )
                  ],
                ));
          }
        }));
  }

  Widget locationInfo(String title, String location, String length) {
    final isDeparture = title == '출발';
    const titleStyle = TextStyle(fontSize: 30);
    const locationStyle = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: titleStyle),
            if (isDeparture && length.isNotEmpty) const SizedBox(width: 8),
            if (isDeparture && length.isNotEmpty)
              Text(length,
                  style: const TextStyle(fontSize: 20, color: Colors.grey)),
          ],
        ),
        Text(location, style: locationStyle),
      ],
    );
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

  Widget text_Button(String text, String route, [BuildContext? context]) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          if (text == '운행 완료' && context != null) {
            showFareInputDialog(context); // 팝업 창 표시
          } else {
            Get.toNamed(route);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              text == '길안내' ? Colors.white : const Color(0xFF1479FF),
          foregroundColor:
              text == '길안내' ? const Color(0xFF1479FF) : Colors.white,
          minimumSize: const Size(200, 50),
          side: text == '길안내'
              ? const BorderSide(color: Color(0xFF1479FF), width: 2)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void showFareInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              '운행 완료',
              style: TextStyle(fontSize: 24),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fareController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '금액 입력',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF1479FF),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF1479FF),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              width: 100,
              height: 50,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0XFF1479FF), width: 2),
                color: Colors.white,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('취소하기',
                    style: TextStyle(color: Color(0XFF1479FF), fontSize: 16)),
              ),
            ),
            Container(
              width: 150,
              height: 50,
              padding: EdgeInsets.zero,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1479FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  int fare = int.parse(fareController.text);
                  if (fare != 0) {
                    driverAcceptController.completeCall(matchingId, fare);
                    Get.toNamed("/drivercomplete",
                        arguments: {'matchingId': matchingId, 'fare': fare});
                  }
                },
                child: const Text('운행 완료하기',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        );
      },
    );
  }

  void completeRide(String fare) {
    // 운행 완료 처리 로직을 여기에 추가
    print("운행이 완료되었습니다. 최종 금액: $fare 원");
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
