import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryPageView extends StatelessWidget {
  const HistoryPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 45.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '최근 이용 내역',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 35.0),
            Expanded(
              child: ListView.builder(
                itemCount: 4, // 실제 데이터 개수로 대체
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/images/hachuping.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('부산 12바 1234', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8.0),
                                    detailText('날짜', '24.08.02'),
                                    detailText('시간', '14:40 ~ 14:47'),
                                    detailText('출발', '부산대학교 정문'),
                                    detailText('도착', '부산대학교 조형관'),
                                    detailText('금액', '4800원'),
                                  ],
                                ),
                              ],
                            ))),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailText(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
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
}
