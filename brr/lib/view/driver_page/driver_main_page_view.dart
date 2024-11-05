import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/mydata_page_controller.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

class DriverMainPageView extends StatefulWidget {
  const DriverMainPageView({super.key});

  @override
  State<DriverMainPageView> createState() => _DriverMainPageViewState();
}

class _DriverMainPageViewState extends State<DriverMainPageView> {
  final MyPageController _myPageController = Get.put(MyPageController());
  @override
  Widget build(BuildContext context) {
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(() =>
                  driverProfile(_myPageController.nickname.value, '효원운수')),
              const SizedBox(height: 15),
              carProfile(_myPageController.car_model.value, _myPageController.car_num.value),
              const SizedBox(height: 15),
              workButton(),
              const SizedBox(height: 5),
              const Text("현재 위치 : 부산광역시 금정구 장전 1동",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ],
          ),
        ));
  }

  Widget driverProfile(String name, String company) {
    return Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF3F8FF),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 235, 241, 249),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFF3F8FF),
            elevation: 1,
            shadowColor: const Color.fromARGB(255, 235, 241, 249),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Get.toNamed('/drivermypage');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.person, size: 25, color: Color(0xFF1479FF)),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black)),
                      const Text(' 기사님',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('(', style: TextStyle(fontSize: 12)),
                      Text(company, style: const TextStyle(fontSize: 12)),
                      const Text(')', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ));
  }

  Widget carProfile(String carType, String carNumber) {
    return Container(
        width: double.infinity,
        height: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFF3F8FF),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 235, 241, 249),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xFFF3F8FF),
              elevation: 1,
              shadowColor: const Color.fromARGB(255, 235, 241, 249),
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/taxi.png',
                    height: 160,
                    width: 160,
                    alignment: Alignment.topLeft,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(carType,
                        style:
                            const TextStyle(fontSize: 25, color: Colors.black)),
                    Text(carNumber,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.black)),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.transparent, // 배경색 투명

                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        '차량정보 수정',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  Widget workButton() {
    return Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFF1479FF),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 235, 241, 249),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(3, 5),
            ),
          ],
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xFF1479FF),
              elevation: 3,
              shadowColor: const Color.fromARGB(255, 28, 137, 226),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Get.toNamed('/driverwork');
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('출근하기',
                    style: TextStyle(fontSize: 35, color: Colors.white)),
              ],
            )));
  }
}
