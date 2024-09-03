import 'package:brr/view/main_page/main_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/mydata_page_controller.dart';

class MypagePageView extends StatelessWidget {
  MypagePageView({Key? key}) : super(key: key);
  final MyPageController _myPageController = Get.put(MyPageController());

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
                      '회원정보',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                profile_custom(100, 100, 80, Color(0xFF1479FF)),
                const SizedBox(height: 10.0),
                Obx(() => Text(
                      _myPageController.nickname.value,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                const SizedBox(height: 50),
                buildRow(context, '시간표 등록', '페이지 이동', '/schedule'),
                buildRow(context, '${_myPageController.nickname.value}님의 회원 정보', '회원 정보 수정', '/mydata'),
                buildRow(context, '이용 기록 확인', '페이지 이동', '/history'),
                buildLogout(context, '로그아웃', '/login'),
                const SizedBox(height: 10),
                Container(
                  height: 190,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFE6F0FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("결제 수단", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextButton(
                                    onPressed: () {},
                                    child: Row(children: [
                                      const Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1479FF),
                                      ),
                                    ),
                                    Text(
                                      ' 추가하기',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    ],)
                                  ),
                      ],),
                                
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 170,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '라이언 치즈 체크카드',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          'NH농협카드',
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        
                                      ],
                                    ),
                                  ),]),
                                
                    ]),   ),
              ],
            )));
  }
}
 