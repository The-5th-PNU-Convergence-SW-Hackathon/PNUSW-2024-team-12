import 'package:flutter/material.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/mydata_page_controller.dart';
import 'package:get/get.dart';

class DriverMypageView extends StatefulWidget {
  const DriverMypageView({Key? key}) : super(key:key);
  @override
  _DriverMyDataPageViewState createState() => _DriverMyDataPageViewState();
}


class _DriverMyDataPageViewState extends State<DriverMypageView> {
  final MyPageController _myPageController = Get.put(MyPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 45.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        )),
                    Text(
                      '기사정보',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    profile_custom(90, 90, 80, Colors.blue),
                    const SizedBox(height: 5.0),
                    Obx(()=>Text(
                      _myPageController.nickname.value,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),)
                  ],
                ),
                const SizedBox(height: 80),
                Obx(() => mydata_custom('이름', _myPageController.nickname.value),),
                const SizedBox(height: 15),
                Obx(() => mydata_custom('아이디', _myPageController.id.value),),
                const SizedBox(height: 15),
                mydata_custom('차량번호', '12가 1234'),
                const SizedBox(height: 15),
                mydata_custom('차량종류', '1톤트럭'),
                buildLogout(context, '로그아웃', '/login'),
                const SizedBox(height: 150),
                Row(children: [
                  modify_button('차량정보 수정', '/drivercarmodify'),
                  const SizedBox(width: 10),
                  modify_button('개인정보 수정', '/driverpasswordmodify'),

                ],)
              ],
            )));
  }

  Widget mydata_custom(String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Color(0xFFE6F0FF),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          width: 200,
          height: 34,
          child: Align(alignment: Alignment.centerRight, child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black))),
        ),
      ],
    );
  }
}

Widget modify_button(String title, String route) {
  return Container(
    width: 160,
    height: 50,
    child : ElevatedButton(
    onPressed: () {
      Get.toNamed(route);
    },
    child: Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1479FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  );
}
