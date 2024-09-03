import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/controller/history_page_controller.dart';
import 'package:brr/model/history_model.dart';
import 'package:brr/design_materials/design_materials.dart';

class DetailHistoryPageView extends StatelessWidget {
  const DetailHistoryPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.arguments를 사용해 전달된 History 객체를 가져옵니다.
    final HistoryDetail detailHistory = Get.arguments as HistoryDetail;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 45.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 24.0),
                  onPressed: () {
                    Get.back();
                  },
                ),
                const Text(
                  '최근 이용 내역',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                profile_custom(100, 100, 80, Color(0xFFCCE0FF)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '택시 정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      detail_text('차량 번호', detailHistory.car_num),
                      const SizedBox(height: 4),
                      detail_text('차종', detailHistory.car_model),
                      const SizedBox(height: 4),
                      detail_text('기사 이름', detailHistory.driver_name),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFF3F8FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFD9E4F5), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '운행정보',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  detail_text('날짜', detailHistory.date.toLocal().toString().split(' ')[0]),
                  detail_text('시간', '${detailHistory.boarding_time} ~ ${detailHistory.quit_time}'),
                  detail_text('출발', detailHistory.depart),
                  detail_text('도착', detailHistory.dest),
                  detail_text('금액', '${detailHistory.amount}원'),
                  const SizedBox(height: 20),
                  const Text(
                    '같이 탄 사람',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (detailHistory.mate.isNotEmpty)
                    detail_mate(detailHistory.mate), // 동승자가 있는 경우 표시
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    '저장하기',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "|",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    '공유하기',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detail_text(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(width: 10.0),
          Text(
            content,
            style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget detail_mate(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          profile_custom(40, 40, 20, Color(0xFFCCE0FF)),
          const SizedBox(width: 10.0),
          Text(
            name,
            style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
