import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/controller/history_page_controller.dart';
import 'package:brr/model/history_model.dart';  // History 모델 임포트

class HistoryPageView extends StatelessWidget {
  const HistoryPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryPageController historyController = Get.put(HistoryPageController());
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
              child: Obx(() {
                if (historyController.historys.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: historyController.historys.length,
                    itemBuilder: (context, index) {
                      final history = historyController.historys[index];
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        history.car_num,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8.0),
                                      detailText('날짜', history.date.toLocal().toString().split(' ')[0]), // 날짜
                                      detailText('시간', '${history.boarding_time} ~ ${history.quit_time}'), // 시간
                                      detailText('출발', history.depart), // 출발지
                                      detailText('도착', history.dest), // 도착지
                                      detailText('금액', '${history.amount}원'), // 금액
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
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
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,  // 길어질 경우 줄임표 처리
            ),
          ),
        ],
      ),
    );
  }
}
