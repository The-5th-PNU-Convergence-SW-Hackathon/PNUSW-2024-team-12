import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideCompletePageView extends StatelessWidget {

  const RideCompletePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = Get.arguments;

    final driver_name = data['driver_name'];
    final car_num = data['car_num'];
    final car_model = data['car_model'];
    final date = data['date'];
    final depart = data['depart'];
    final dest = data['dest'];
    final boarding_time = data['boarding_time'];
    final quit_time = data['quit_time'];
    final amount = data['amount'];
    return SafeArea(child: 
    Scaffold(
      backgroundColor: Colors.white,
      body : Padding(padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 45.0),
      child : Column(children: [
        Column(
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
                    Text(
              '총 ${amount}원이 자동결제 되었어요!',
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
                  buildInfoRow('차량 번호', car_num),
                  buildInfoRow('차종', car_model),
                  buildInfoRow('기사 이름', driver_name),
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
                  buildInfoRow('시간', '$boarding_time - $quit_time'),
                  buildInfoRow('출발', depart),
                  buildInfoRow('도착', dest),
                  buildInfoRow('금액', amount.toString()),
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