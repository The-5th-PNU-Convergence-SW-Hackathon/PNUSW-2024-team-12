import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';

class CallAcceptPageView extends StatelessWidget {
  final String depart;
  final String dest;

  CallAcceptPageView({required this.depart, required this.dest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            titleSpacing: 25.0,
            title: Row(
              children: [brrLogo(), const SizedBox(width: 22), const Text('기사앱', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))],
            )),
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                locationInfo('출발', depart, '현재 위치에서 3km'),
                CustomPaint(
                  size: Size(40, 40),
                  painter: ArrowPainter(),
                ),
                locationInfo('도착', dest, ''),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    detailInfo('예상요금/거리', '16780원/25km'),
                    detailInfo('소요시간', '28분'),
                  ],
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    callButton('수락하기', Colors.blue, Colors.white, 200, () {}),
                    const SizedBox(width: 15),
                    callButton('거절', const Color.fromARGB(255, 218, 218, 218), Colors.black, 120, () {
                      Navigator.pop(context);
                    }),
                  ],
                )
              ],
            )));
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

  Widget callButton(String text, Color backgroundColor, Color textColor, double width, VoidCallback onPressed) {
    return Container(
      width: width,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          textStyle: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
          ),
          elevation: 7,
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
