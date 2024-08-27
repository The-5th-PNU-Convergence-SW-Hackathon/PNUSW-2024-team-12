import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/constants/bottom_navigation/bottom_navigation_controller.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/join_match_controller.dart';
import 'package:brr/controller/quickmatch_list_controller.dart';

class MainPageView extends StatelessWidget {
  MainPageView({super.key});
  final QuickMatchController quickMatchController = Get.put(QuickMatchController());
  final JoinMatchController joinMatchController = Get.put(JoinMatchController());
  final _bottomNavController = Get.put(MyBottomNavigationBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                            buildElevatedButton("빠른 매칭", Icons.link, '/writelocation'),
                            const SizedBox(width: 10),
                            buildElevatedButton("매칭 예약", Icons.alarm, '/reservation'),
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
                                  onPressed: () {
                                    joinMatchController.joinMatch(quickMatch.id);
                                  },
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
                    ),
                  )
                ]),
              ))
        ]));
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: Color(0xFFF2F2F2), width: 1.0),
      ),
      elevation: 0,
    );
  }

  Widget locationRow(Widget icon, String label, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 10.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.0,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget boardingInfo(String boardingTime) {
    return Text(
      "오늘 $boardingTime 탑승 예정",
      style: const TextStyle(
        fontSize: 10.0,
      ),
    );
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

  Widget buildElevatedButton(String text, IconData icon, String destination) {
    return ElevatedButton.icon(
      onPressed: () {
        Get.toNamed(destination);
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
