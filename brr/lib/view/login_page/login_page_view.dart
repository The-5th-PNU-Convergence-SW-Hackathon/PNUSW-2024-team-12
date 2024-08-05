import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData( fontFamily: "Pretendard" ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              brrLogo(),
              const SizedBox( height: 80 ),
              //축약 필요
              logInTextField('아이디', false),
              logInTextField('비밀번호', true),

              const SizedBox( height: 25 ),

              SizedBox(
                width: 270,
                child: OutlinedButton(
                  onPressed:(){
                    Get.toNamed("/");
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                  child: const Text( '로그인', style: TextStyle( color: Colors.black ) )
                )
              ),
              const SizedBox( height: 10 ),

              SizedBox(
                width: 270,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed:(){}, child: const Text(
                        '아이디/비밀번호 찾기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff767676),
                          decoration: TextDecoration.underline
                        ),
                      )
                    ),
                    TextButton(
                      onPressed:(){
                        Get.toNamed("/signup");
                      }, child: const Text(
                      '회원가입',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff767676),
                          decoration: TextDecoration.underline
                      ),
                    )
                    )
                  ],
                ),
              )

            ],
          ),
        )
      )
    );
  }
}