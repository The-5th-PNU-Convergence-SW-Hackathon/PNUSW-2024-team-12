import 'package:brr/design_materials/design_materials.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/view/loading_circle/loading_circle.dart';

class TaxiLoadingPageView extends StatelessWidget {
  const TaxiLoadingPageView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  '수락을 대기 중이에요',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
              ],
            ),
          ),
          // Positioned(top: 50.0, left: 30.0, child: gobackButton())
        ],
      ),
    );
  }
}
