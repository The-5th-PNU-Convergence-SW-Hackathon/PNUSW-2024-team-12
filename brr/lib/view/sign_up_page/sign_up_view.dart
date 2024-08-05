import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpView> {
  bool isNormalAcc = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Pretendard"),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
/*              Navigator.pop(context);*/
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              brrLogo(),
              const SizedBox( height: 34, ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: (){
                      setState(() {
                        isNormalAcc = true;
                      });
                    },
                    child: Text( '회원으로 가입', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w800,
                        color: isNormalAcc ? Colors.black : Colors.grey ), ),
                  ),

                  Container(
                    width: 1,
                    height: 14.5,
                    color: Colors.black,
                  ),

                  TextButton(
                    onPressed: (){
                      setState(() {
                        isNormalAcc = false;
                      });
                    },
                    child: Text( '택시기사로 가입', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w800,
                        color: isNormalAcc ? Colors.grey : Colors.black ), ),
                  ),
                ],
              ),
              const SizedBox( height: 34 ),

              isNormalAcc ? const NormalSignUp() : const DriverSignUp(),

              const SizedBox( height: 33 ),

              SizedBox(
                  width: 270,
                  child: OutlinedButton(
                      onPressed:(){
                        isNormalAcc ? Get.toNamed("/") : Get.toNamed("/drivermain");
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                      child: const Text( '가입하기' , style: TextStyle( color: Colors.black ) )
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
                          Get.toNamed("/login");
                        }, child: const Text(
                      '로그인',
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
        ),
      ),
    );
  }
}

class NormalSignUp extends StatefulWidget {
  const NormalSignUp({super.key});

  @override
  State<NormalSignUp> createState() => _NormalSignUpState();
}

class _NormalSignUpState extends State<NormalSignUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        logInTextField('아이디', false),
        logInTextField('비밀번호', true),
        logInTextField('비밀번호 확인', true),
        logInTextField('전화번호', false),
        logInTextField('학번', false),
      ],
    );
  }
}

class DriverSignUp extends StatefulWidget {
  const DriverSignUp({super.key});

  @override
  State<DriverSignUp> createState() => _DriverSignUpState();
}

class _DriverSignUpState extends State<DriverSignUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        logInTextField('아이디', false),
        logInTextField('비밀번호', true),
        logInTextField('비밀번호 확인', true),
        logInTextField('전화번호', false),

        const SizedBox( height: 24 ),

        TextButton(onPressed: (){},
          style: TextButton.styleFrom(
            minimumSize: Size.zero
          ),
          child: const Text('운수사업자등록번호 확인 >',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w700,
              color: Colors.black
            ),
          )
        ),

        const SizedBox( height: 10 ),

        TextButton(onPressed: (){},
          style: TextButton.styleFrom(
            minimumSize: Size.zero
          ),
          child: const Text('면허증 인증 >',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w700,
              color: Colors.black
            ),
          )
        ),
      ],
    );
  }
}



