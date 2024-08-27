import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/view/loading_circle/loading_circle.dart';
import 'package:brr/controller/quickmatch_list_controller.dart';

class DriverWorkPageView extends StatefulWidget {
  DriverWorkPageView({super.key});

  @override
  State<DriverWorkPageView> createState() => _DriverWorkPageView();
}

class _DriverWorkPageView extends State<DriverWorkPageView> {
  final QuickMatchController quickMatchController = Get.put(QuickMatchController());

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
        body: Stack(
          children: [
            Positioned.fill(
              child: Padding(
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
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.57,
              minChildSize: 0.12,
              maxChildSize: 0.65,
              builder: (context, scrollController) {
                return Container(
                    decoration: const BoxDecoration(color: Color(0xFFF3F8FF), borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    child: ListView(controller: scrollController, children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                              ),
                              const SizedBox(height: 15),
                              Obx(() {
                                if (quickMatchController.quickMatches.isEmpty) {
                                  return const Center(child: Text("빠른 매칭이 없습니다."));
                                }
                                int itemCount = quickMatchController.quickMatches.length < 3 ? quickMatchController.quickMatches.length : 3;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: itemCount,
                                  itemBuilder: (context, index) {
                                    int reverseIndex = quickMatchController.quickMatches.length - index - 1;
                                    final quickMatch = quickMatchController.quickMatches[reverseIndex];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: ElevatedButton(
                                        style: buttonStyle(),
                                        onPressed: () {},
                                        child: Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                locationRow(circleContainer, "출발지", quickMatch.depart),
                                                const SizedBox(height: 5.0),
                                                locationRow(rectangularContainer, "도착지", quickMatch.dest),
                                              ],
                                            ),
                                            const Spacer(),
                                            boardingInfo(quickMatch.boardingTime.toString().substring(11, 16)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ],
                          ))
                    ]));
              },
            )
          ],
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
            onPressed: () {
              Get.toNamed('/drivermain');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('콜 멈추기', style: const TextStyle(fontSize: 35, color: Colors.white)),
              ],
            )));
  }
}
