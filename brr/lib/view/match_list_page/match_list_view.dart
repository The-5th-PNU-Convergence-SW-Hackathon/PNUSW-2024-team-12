import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/controller/quickmatch_list_controller.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/reservation_match_list_controller.dart';
import 'package:brr/controller/join_match_controller.dart';

class MatchinglistPageView extends StatefulWidget {
  const MatchinglistPageView({super.key});

  @override
  _MatchinglistPageView createState() => _MatchinglistPageView();
}

class _MatchinglistPageView extends State<MatchinglistPageView> {
  final QuickMatchController quickMatchController = Get.put(QuickMatchController());
  final ReservationMatchController reservationMatchController = Get.put(ReservationMatchController());
  final JoinMatchController joinMatchController = Get.put(JoinMatchController());

  bool isQuickMatch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 45.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '매칭',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: isQuickMatch ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isQuickMatch = true;
                      });
                    },
                    child: const Text('빠른 매칭', style: TextStyle(fontSize: 16.0)),
                  ),
                ),
                const Text(' / ', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: isQuickMatch ? Colors.grey : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isQuickMatch = false;
                      });
                    },
                    child: const Text('매칭 예약', style: TextStyle(fontSize: 16.0)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            rectangularContainer,
                            const SizedBox(width: 10.0),
                            const Text(
                              "도착지",
                              style: TextStyle(
                                fontSize: 10.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Expanded(
                              child: TextField(
                                cursorColor: Colors.black,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: "도착지를 입력해주세요",
                                  hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  contentPadding: EdgeInsets.only(bottom: 9.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(child: Obx(() {
              if (quickMatchController.quickMatches.isEmpty && isQuickMatch) {
                return const Center(child: Text("빠른 매칭이 없습니다."));
              }
              return ListView.builder(
                  itemCount: isQuickMatch ? quickMatchController.quickMatches.length : reservationMatchController.ReservationMatches.length,
                  itemBuilder: (context, index) {
                    if (isQuickMatch) {
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
                    } else {
                      int reverseIndex = reservationMatchController.ReservationMatches.length - index - 1;
                      final reservationMatch = reservationMatchController.ReservationMatches[reverseIndex];
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
                                  locationRow(circleContainer, "출발지", reservationMatch.depart),
                                  const SizedBox(height: 5.0),
                                  locationRow(rectangularContainer, "도착지", reservationMatch.dest),
                                ],
                              ),
                              const Spacer(),
                              boardingInfo(reservationMatch.boardingTime.toString().substring(11, 16)),
                            ],
                          ),
                        ),
                      );
                    }
                  });
            }))
          ],
        ),
      ),
    );
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
}
