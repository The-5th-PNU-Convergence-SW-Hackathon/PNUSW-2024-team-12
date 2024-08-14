import 'package:flutter/material.dart';

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
