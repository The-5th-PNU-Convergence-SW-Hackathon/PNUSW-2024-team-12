import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideCompletePageView extends StatelessWidget {
  final String taxiNumber = '부산 12바 2901';
  final String carModel = '아이오닉 5';
  final String driverName = '이지헌 기사님';
  final String date = '24.09.04';
  final String time = '16:31 - 16:32';
  final String departure = '부산대학교 정문';
  final String destination = '부산대학교 조형관';
  final String fare = '4,800원';

  const RideCompletePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    Scaffold(
      backgroundColor: Colors.white,
      body : Padding(padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 45.0),
      child : Column(children: [
        const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '운행 완료',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Text(
              '총 4,800원이 자동결제 되었어요!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),),
          ],
        ),
                
              
              

            
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F0FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '택시 정보',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildInfoRow('차량 번호', taxiNumber),
                  buildInfoRow('차종', carModel),
                  buildInfoRow('기사 이름', driverName),
                  const SizedBox(height: 20),
                  const Text(
                    '운행정보',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildInfoRow('날짜', date),
                  buildInfoRow('시간', time),
                  buildInfoRow('출발', departure),
                  buildInfoRow('도착', destination),
                  buildInfoRow('금액', fare),
                ],
              ),
            ),
             const Spacer(),
            Center(
              child: Container(
                width: double.infinity,
                height: 40,
                child : ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1479FF),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '홈 화면으로 돌아가기',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              )
            ),
            
      ],))
    ));
  }

  Widget buildInfoRow(String title, String value) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF676767),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          
        ],
      
    );
  }
}