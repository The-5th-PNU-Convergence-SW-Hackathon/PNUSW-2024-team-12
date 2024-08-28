import 'package:flutter/material.dart';
import 'package:get/get.dart';

///로그인, 회원가입 페이지 TextField
///
///[labelText]: TextField의 labelText 설정
///[obscure]: 입력한 문자 숨김 여부 (비밀번호)
dynamic logInTextField(String labelText, TextEditingController controller) {
  //로그인, 회원가입 페이지 TextField
  return Container(
      width: 270,
      height: 48,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xffCCE0FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
          obscureText: false,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 14),
            contentPadding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            border: InputBorder.none,
          )));
}

dynamic logInPWTextField(
  String labelText,
  TextEditingController controller,
  bool isPasswordHidden,
  VoidCallback onIconPressed,
) {
  //로그인, 회원가입 페이지 TextField
  return Container(
      width: 270,
      height: 48,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xffCCE0FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
          controller: controller,
          obscureText: isPasswordHidden,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 14),
            contentPadding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordHidden ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onIconPressed,
            ),
          )));
}

///BRR Logo
///
/// 폰트 사이즈를 입력하지 않을 시 36으로 설정됨 (로그인 화면 폰트 사이즈)
dynamic brrLogo({double size = 36}) {
  return SizedBox(
    child: Stack(
      children: <Widget>[
        Text(
          'BRR',
          style: TextStyle(
            fontSize: size,
            fontFamily: 'AnonymousPro-BoldItalic',
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1
              ..color = Colors.black,
          ),
        ),
        Text('BRR', style: TextStyle(fontSize: size, fontWeight: FontWeight.w900, fontFamily: 'AnonymousPro-BoldItalic'))
      ],
    ),
  );
}

final Widget circleContainer = Container(
  width: 8,
  height: 8,
  decoration: const BoxDecoration(
    color: Color.fromARGB(255, 182, 232, 255),
    shape: BoxShape.circle,
  ),
);

final Widget rectangularContainer = Container(
  width: 8,
  height: 8,
  decoration: const BoxDecoration(
    color: Colors.blue,
    shape: BoxShape.rectangle,
  ),
);

Widget gobackButton() {
  return SizedBox(
    width: 35.0,
    height: 35.0,
    child: FloatingActionButton(
      onPressed: () {
        Get.back();
      },
      shape: const CircleBorder(),
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
      elevation: 4.0,
      child: const Icon(
        Icons.arrow_back,
        size: 20.0,
      ),
    ),
  );
}

Widget BRRcashIcon() {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        "B",
        style: TextStyle(
          fontSize: 30,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    ),
  );
}

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: const BorderSide(color: Color(0xFFF2F2F2), width: 1.0),
    ),
    elevation: 0,
  );
}

Widget locationRow(Widget icon, String label, String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      icon,
      const SizedBox(width: 10.0),
      Text(
        label,
        style: const TextStyle(
          fontSize: 10.0,
        ),
      ),
      const SizedBox(width: 10.0),
      Text(
        text,
        style: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget boardingInfo(String boardingTime) {
  return Text(
    "오늘 $boardingTime 탑승 예정",
    style: const TextStyle(
      fontSize: 10.0,
    ),
  );
}

Widget profile_custom(double garo, double sero, double iconSize, Color color) {
  return Container(
    width: garo,
    height: sero,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(Icons.person, color: Colors.white, size: iconSize),
  );
}

Widget buildRow(BuildContext context, String title, String buttonText, String routeName) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
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

Widget buildLogout(BuildContext context, String buttonText, String routeName) {
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
