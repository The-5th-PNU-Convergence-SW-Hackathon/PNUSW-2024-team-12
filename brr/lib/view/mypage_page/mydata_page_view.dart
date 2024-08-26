import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/controller/mydata_controller.dart';

class MyDataPageView extends StatefulWidget {
  const MyDataPageView({Key? key}) : super(key: key);

  @override
  _MyDataPageViewState createState() => _MyDataPageViewState();
}

class _MyDataPageViewState extends State<MyDataPageView> {
  final TextEditingController _pwController = TextEditingController(text: '1234');

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
            const MyDataTextField(text: '회원이름', mydata: '안선주'),
            const MyDataTextField(text: '아이디', mydata: 'sunju'),
            PassWordTextField(
              text: '비밀번호',
              controller: _pwController,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Container(
                            width: 300,
                            height: 200,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                              const Text(
                                '수정 완료',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const Text(
                                '회원 정보가 성공적으로 수정되었습니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Get.toNamed("/mypage");
                                },
                                child: const Text('확인', style: TextStyle(fontSize: 14, color: Colors.white)),
                              ),
                            ])),
                      );
                    },
                  );
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

class MyDataTextField extends StatelessWidget {
  final String text;
  final String mydata;

  const MyDataTextField({
    Key? key,
    required this.text,
    required this.mydata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
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
              width: 200,
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xffCCE0FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Center(
                    child: TextField(
                      cursorColor: Colors.blue,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: mydata,
                        labelStyle: const TextStyle(fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ))),
        ],
      ),
    );
  }
}

class PassWordTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  const PassWordTextField({
    Key? key,
    required this.text,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PasswordController passwordController = Get.put(PasswordController());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
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
            width: 200,
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xffCCE0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.blue,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(fontSize: 14),
                            controller: controller,
                            obscureText: !passwordController.isPasswordVisible.value,
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            passwordController.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                            size: 15,
                          ),
                          onPressed: passwordController.togglePasswordVisibility,
                        ),
                      ],
                    ),
                  ));
            }),
          ),
        ],
      ),
    );
  }
}
