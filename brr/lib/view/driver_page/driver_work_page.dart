import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/view/loading_circle/loading_circle.dart';

class DriverWorkPageView extends StatefulWidget {
  DriverWorkPageView({super.key});

  @override
  State<DriverWorkPageView> createState() => _DriverWorkPageView();
}

class _DriverWorkPageView extends State<DriverWorkPageView> {
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
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              BouncingDots(),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '콜 대기 중',
                    style: const TextStyle(fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text("부산광역시 금정구", style: const TextStyle(fontSize: 15, color: Colors.black)),
                ],
              ),
              const SizedBox(height: 50),
              stopButton(),
              const SizedBox(height: 5),
            ],
          ),
        ));
  }

  Widget stopButton() {
    return Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 235, 241, 249),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(3, 5),
            ),
          ],
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.blue,
              elevation: 3,
              shadowColor: const Color.fromARGB(255, 28, 137, 226),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('콜 멈추기', style: const TextStyle(fontSize: 35, color: Colors.white)),
              ],
            )));
  }
}
