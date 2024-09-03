import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/driver_call_controller.dart';
import 'package:get/get.dart';

class DriverDecideNavigationPageView extends StatelessWidget {
  final int matchingId;

  DriverDecideNavigationPageView({required this.matchingId});

  final DriverAcceptController driverAcceptController = Get.put(DriverAcceptController());

  @override
  Widget build(BuildContext context) {
    driverAcceptController.fetchCallInfo(matchingId);

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            titleSpacing: 25.0,
            title: Row(
              children: [
                brrLogo(),
                const SizedBox(width: 22),
                const Text('기사앱', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
              ],
            )),
        backgroundColor: Colors.white,
        body: Obx(() {
          if (driverAcceptController.callInfo.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            var callInfo = driverAcceptController.callInfo;
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    locationInfo('출발', callInfo['depart'], '현재 위치에서 3km'),
                    CustomPaint(
                      size: Size(40, 40),
                      painter: ArrowPainter(),
                    ),
                    locationInfo('도착', callInfo['dest'], ''),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        detailInfo('예상요금/거리', '${callInfo['taxi_fare']}원/${callInfo['distance']}km'),
                        detailInfo('소요시간', '${callInfo['duration']}분'),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(children: [
                      text_Button('길안내','drivermain'),
                      const SizedBox(height: 20),
                      text_Button('운행 완료','drivermain'),
                    ],)
                  ],
                ));
          }
        }));
  }

  Widget locationInfo(String title, String location, String length) {
    final isDeparture = title == '출발';
    final titleStyle = TextStyle(fontSize: 30);
    final locationStyle = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: titleStyle),
            if (isDeparture && length.isNotEmpty) SizedBox(width: 8),
            if (isDeparture && length.isNotEmpty) Text(length, style: TextStyle(fontSize: 20, color: Colors.grey)),
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
        Text(title, style: TextStyle(fontSize: 15, color: Colors.black)),
        Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }

  Widget text_Button (String text, String route) {
    return Container(
      width: 200,
      height: 50,
      child:  ElevatedButton(
      onPressed: () {
        Get.toNamed(route);
      },
      child: Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: text == '길안내' ? Colors.white : Color(0xFF1479FF),
        foregroundColor: text == '길안내' ? Color(0xFF1479FF) : Colors.white,
        minimumSize: Size(200, 50), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
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
