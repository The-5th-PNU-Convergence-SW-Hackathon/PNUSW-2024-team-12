import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/mydata_page_controller.dart';

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
              children: [brrLogo(), const SizedBox(width: 22), const Text('기사앱', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))],
            )),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(()=> driverProfile(_myPageController.nickname.value, '효원운수')),
              const SizedBox(height: 15),
              carProfile('아이오닉5 / 중형/ 모범', '부산 12바 2901'),
              const SizedBox(height: 15),
              workButton(),
              const SizedBox(height: 5),
              const Text("현재 위치 : 부산광역시 금정구 장전 1동", style: const TextStyle(fontSize: 20, color: Colors.black)),
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
          color: Color(0xFFF3F8FF),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 235, 241, 249),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Color(0xFFF3F8FF),
            elevation: 1,
            shadowColor: Color.fromARGB(255, 235, 241, 249),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  const Icon(Icons.person, size: 25, color: Colors.blue),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                      Text(' 기사님', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                    ],
                  ),
                  Row(
                    children: [
                      Text('(', style: const TextStyle(fontSize: 12)),
                      Text(company, style: const TextStyle(fontSize: 12)),
                      Text(')', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 20),
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
          color: Color(0xFFF3F8FF),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 235, 241, 249),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Color(0xFFF3F8FF),
              elevation: 1,
              shadowColor: Color.fromARGB(255, 235, 241, 249),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/hachuping.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(carType, style: const TextStyle(fontSize: 25, color: Colors.black)),
                    Text(carNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.black)),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.transparent, // 배경색 투명

                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.black),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
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
            onPressed: () {
              Get.toNamed('/driverwork');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('출근하기', style: const TextStyle(fontSize: 35, color: Colors.white)),
              ],
            )));
  }
}
