import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/controller/history_page_controller.dart';

class DetailHistoryPageView extends StatelessWidget {
  const DetailHistoryPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                profile_custom(100, 100, 80),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('차량 번호'),
                          Text('부산 12바 1234'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('차종'),
                          Text('아이오닉 5'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('기사 이름'),
                          Text('이지현 기사님'),
                        ],
                      ),
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
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '운행정보',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    detail_text('날짜', '24.08.02'),
                    detail_text('시간', '12:00 ~ 13:00'),
                    detail_text('출발', '부산대학교'),
                    detail_text('도착', '부산대학교 조형관'),
                    detail_text('금액', '4800원'),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '같이 탄 사람',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    detail_mate("t1"),
                    const SizedBox(height: 3),
                    detail_mate("h1"),
                    const SizedBox(height: 3),
                    
                  ],
                )),
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
                  children: [
                    const Text(
                      '저장하기',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const Text(
                      '공유하기',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ))
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          profile_custom(40, 40, 20),
          const SizedBox(width: 10.0),
          Text(
            name,
            style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget profile_custom(double garo, double sero, double iconSize) {
    return Container(
      width: garo,
      height: sero,
      decoration: BoxDecoration(
        color: Color(0xFFCCE0FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.person, color: Colors.white, size: iconSize),
    );
  }
}
