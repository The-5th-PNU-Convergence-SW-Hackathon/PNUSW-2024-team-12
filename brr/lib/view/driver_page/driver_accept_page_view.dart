import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/driver_call_controller.dart';
import 'package:get/get.dart';

class CallAcceptPageView extends StatelessWidget {
  final int matchingId;

  CallAcceptPageView({super.key, required this.matchingId});

  final DriverAcceptController driverAcceptController =
      Get.put(DriverAcceptController());

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
                const Text('기사앱',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
              ],
            )),
        backgroundColor: Colors.white,
        body: Obx(() {
          if (driverAcceptController.callInfo.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var callInfo = driverAcceptController.callInfo;
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
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        callButton('수락하기', 200, () {
                          driverAcceptController.acceptCall(matchingId);
                          Get.toNamed('/decidenavigation',
                              arguments: matchingId);
                        }),
                        const SizedBox(width: 10),
                        callButton('거절', 120, () {
                          Navigator.pop(context);
                        }),
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

  Widget callButton(String text, double width, VoidCallback onPressed) {
    return SizedBox(
      width: width,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor:
              text == '수락하기' ? Colors.white : const Color(0xFF1479FF),
          backgroundColor:
              text == '수락하기' ? const Color(0xFF1479FF) : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: const BorderSide(color: Color(0xFF1479FF), width: 2)),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          textStyle: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          shadowColor: Colors.blue.withOpacity(0.3),
        ),
        onPressed: onPressed,
        child: Text(text),
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
