import 'package:brr/controller/mydata_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDataPageView extends StatefulWidget {
  const MyDataPageView({Key? key}) : super(key: key);

  @override
  _MyDataPageViewState createState() => _MyDataPageViewState();
}

class _MyDataPageViewState extends State<MyDataPageView> {
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
            Obx(() => Text(
                  _myPageController.nickname.value,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 50),
            const Center(
                child: SizedBox(
                    width: 140,
                    child: Column(
                      children: [
                        CheckBox(text: '일반 회원 계정'),
                        CheckBox(text: '기사 계정'),
                      ],
                    ))),
            const SizedBox(height: 50),
            Obx(() => mydata_custom('닉네임', _myPageController.nickname.value)),
            const SizedBox(height: 5),
            Obx(() => mydata_custom('아이디', _myPageController.id.value)),
            const SizedBox(height: 5),
            PassWordTextField(
              text: '현재 비밀번호',
              controller: _myPageController.pwController,
            ),
            const SizedBox(height: 5),
            PassWordTextField(
              text: '새 비밀번호',
              controller: _myPageController.newPwController,
            ),
            const SizedBox(height: 5),
            PassWordTextField(
              text: '새 비밀번호 확인',
              controller: _myPageController.newPwCheckController,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  _myPageController.changePwdButton();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text('수정하기',
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
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
          width: 180,
          height: 34,
          child: Align(alignment: Alignment.centerRight, child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black))),
        ),
      ],
    );
  }
}

class PassWordTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final RxBool isPasswordVisible = false.obs;

  PassWordTextField({
    Key? key,
    required this.text,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 5),
        Container(
          width: 180,
          height: 35,
          padding: const EdgeInsets.only(right: 10, left: 5),
          decoration: BoxDecoration(
            color: Color(0xFFE6F0FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() {
            return Row(
              children: [
                IconButton(
                  icon: Icon(
                    isPasswordVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 15,
                  ),
                  onPressed: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                ),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: controller,
                    obscureText: !isPasswordVisible.value,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class CheckBox extends StatelessWidget {
  final String text;

  const CheckBox({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: text == '일반 회원 계정'
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.blue,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ));
  }
}
