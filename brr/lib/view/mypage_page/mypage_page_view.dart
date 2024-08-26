import 'package:brr/view/main_page/main_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';

class MypagePageView extends StatelessWidget {
  const MypagePageView({Key? key}) : super(key: key);

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
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  '안선주',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                _buildRow(context, '시간표 등록', '페이지 이동', '/schedule'),
                _buildRow(context, '선주님의 회원 정보', '회원 정보 수정', '/mydata'),
                _buildRow(context, '이용 기록 확인', '페이지 이동', '/history'),
                _buildLogout(context, '로그아웃', '/login'),
                const SizedBox(height: 10),
                Container(
                  height: 180,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "부르릉 캐시",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Icon(Icons.add, size: 15, color: Colors.blue),
                                SizedBox(width: 3),
                                Text(
                                  '충전하기',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BRRcashIcon(),
                          SizedBox(width: 10),
                          Text(
                            "15,800 캐시",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget _buildRow(BuildContext context, String title, String buttonText, String routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.toNamed(routeName);
            },
            child: Row(
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogout(BuildContext context, String buttonText, String routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          TextButton(
            onPressed: () {
              Get.offAllNamed(routeName);
            },
            child: Row(
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
