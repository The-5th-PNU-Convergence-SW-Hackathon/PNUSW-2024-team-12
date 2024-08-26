import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/constants/bottom_navigation/bottom_navigation_controller.dart';
import 'package:brr/design_materials/design_materials.dart';

class MainPageView extends StatelessWidget {
  MainPageView({super.key});

  final _bottomNavController = Get.put(MyBottomNavigationBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          leading: const SizedBox(),
          flexibleSpace: FlexibleSpaceBar(titlePadding: const EdgeInsetsDirectional.only(start: 25.0), title: Align(alignment: Alignment.centerLeft, child: brrLogo()))),
      SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
              buildContainer(
                height: 150,
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "택시 매칭하기",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildElevatedButton("빠른 매칭", Icons.link),
                        const SizedBox(width: 10),
                        buildElevatedButton("매칭 예약", Icons.alarm),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              buildContainer(
                height: 200,
                color: const Color.fromARGB(255, 243, 248, 255),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "예약 목록이 없습니다.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "매칭 예약 하러 가기",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              buildContainer(
                color: const Color.fromARGB(255, 243, 248, 255),
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "*** 님의 시간표에 맞는 목적지 입니다.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 4,
                          height: 36,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "발상과 표현",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "09:00 ~ 10:30, 704-406",
                              style: TextStyle(
                                fontSize: 8,
                                color: Color.fromARGB(255, 153, 153, 153),
                              ),
                            ),
                            Text(
                              "15분 후 수업이 시작합니다.",
                              style: TextStyle(
                                fontSize: 8,
                                color: Color.fromARGB(255, 153, 153, 153),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 155,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(
                              Icons.location_on,
                              size: 15,
                              color: Colors.blue,
                            ),
                            label: const Text(
                              "부산대학교\n조형관",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.visible,
                              ),
                              softWrap: true,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "목적지를 이곳으로 선택",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 248, 255),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "매칭 목록",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.refresh, size: 20))
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed("/matchlist");
                            _bottomNavController.changeIndex(0);
                          },
                          child: const Text(
                            "더보기",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(3, (index) {
                        return Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0.5,
                                padding: const EdgeInsets.all(10),
                              ),
                              child: const Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.circle, size: 8, color: Colors.blue),
                                          SizedBox(width: 5),
                                          Text(
                                            "출발지",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "서브웨이 부산대점",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.square, size: 8, color: Colors.blue),
                                          SizedBox(width: 5),
                                          Text(
                                            "도착지",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "부산역 (고속철도)",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                    "12:00 탑승 예정",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (index < 2) const SizedBox(height: 10),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              )
            ]),
          ))
    ]));
  }

  Widget buildContainer({
    required Widget child,
    double height = double.infinity,
    double width = double.infinity,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget buildElevatedButton(String text, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        Get.toNamed('/matching');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(icon, size: 15),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
