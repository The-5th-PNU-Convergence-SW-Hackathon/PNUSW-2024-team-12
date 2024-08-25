import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/location_controller.dart';

class CompleteMatchingViewPage extends StatelessWidget {
  const CompleteMatchingViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = Get.arguments;

    final taxiId = data['taxi_id'];
    final driverName = data['driver_name'];
    final carNum = data['car_num'];
    final phoneNumber = data['phone_number'];
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.blueGrey,
            child: const Center(
              child: Image(
                image: AssetImage('assets/images/map.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.24,
            minChildSize: 0.12,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: ListView(
                    controller: scrollController,
                    children: [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                driverCard(driverName, carNum),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                      circleContainer,
                                      const SizedBox(width: 5),
                                      Text(
                                        "약 3분 후 도착",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ]),
                                    Row(
                                      children: [
                                        circleContainer,
                                        const SizedBox(width: 5),
                                        Text(
                                          "목적지 부산역 (고속철도)",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            contactRow("기사님께 연락하기...", Icon(Icons.phone, color: Colors.blue, size: 20)),
                            const SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "매칭 완료",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "안선주 이지헌",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            contactRow("매칭된 사람들과 연락하기...", Icon(Icons.chat, color: Colors.blue, size: 20)),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "예상 결제 비용",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 180,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "부르릉 캐시",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: [
                                            Icon(Icons.add, size: 15, color: Colors.blue),
                                            SizedBox(width: 3),
                                            Text(
                                              '충전하기',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BRRcashIcon(),
                                      SizedBox(width: 10),
                                      Text(
                                        "15,800 캐시",
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            }),
        Positioned(
          top: 50.0,
          left: 30.0,
          child: Row(
            children: [
              const SizedBox(width: 10.0),
              ElevatedButton(
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
                      locationRow(circleContainer, '출발지', '부산대학교 정문'),
                      const SizedBox(height: 5.0),
                      locationRow(rectangularContainer, '도착지', '부산대학교 정문'),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    )));
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

  Widget driverCard(String driverName, String carNum) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    carNum,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget contactRow(String title, Widget icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const Icon(
                  Icons.near_me,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: icon,
          ),
        ),
      ],
    );
  }
}
