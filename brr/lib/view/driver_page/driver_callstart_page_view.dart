import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';

class DriverCallstartPageView extends StatefulWidget {
  const DriverCallstartPageView({Key? key}) : super(key: key);

  @override
  _DriverCallstartPageViewState createState() => _DriverCallstartPageViewState();
}

class _DriverCallstartPageViewState extends State<DriverCallstartPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            
            Positioned.fill(
              top: 20.0,
              left: 20.0,
              child: Text(
                'data',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            
            Positioned(
              top: 50.0,
              left: 30.0,
              child: Container(
                width: 360.0,
                child : ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.1),
                ),
                child: SizedBox(
                  width: 270.0,
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      locationRow(circleContainer, '출발지', 'depart'),
                      const SizedBox(height: 5.0),
                      locationRow(rectangularContainer, '도착지', 'dest'),
                    ],
                  ),
                ),
              ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

Widget locationRow(Widget icon, String title, String subtitle) {
  return Row(
    children: [
      icon,
      const SizedBox(width: 10.0),
      Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      const SizedBox(width: 5.0),
      Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
