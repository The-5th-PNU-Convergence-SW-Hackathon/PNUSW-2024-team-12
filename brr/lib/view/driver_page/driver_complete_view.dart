import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/driver_call_controller.dart';
import 'package:get/get.dart';

class DriverCompletePageView extends StatelessWidget {
  final int matchingId;

  DriverCompletePageView({required this.matchingId});

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
        body: Column(
          children: [
            Obx(() {
          if (driverAcceptController.callInfo.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            var callInfo = driverAcceptController.callInfo;
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F8FF),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 200,
                  child : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(callInfo['depart'], style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    
                    CustomPaint(
                      size: Size(40, 40),
                      painter: ArrowPainter(),
                    ),
                    Text(callInfo['dest'], style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    

                    const SizedBox(height: 40),
                   

                  ],
                ),
                
                ),
                Container(
  child: ElevatedButton(
    onPressed: () {
      Get.toNamed('/drivermain');
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1479FF),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
    ),
    child: Text(
      '콜 리스트 돌아가기',
      style: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
  ),
),
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
        Text(title, style: TextStyle(fontSize: 15, color: Colors.black)),
        Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
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
