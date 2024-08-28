import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:brr/constants/url.dart';

class UserSignUpPageController extends GetxController {
  final idController = TextEditingController();
  final pwdController = TextEditingController();
  final pwdCheckController = TextEditingController();
  final nicknameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final classNumberController = TextEditingController();
  final emailController = TextEditingController();
  bool isEmailVerified = false;

  final RegExp idPwdRegExp = RegExp(r'^[a-zA-Z0-9]+$');
  final RegExp generalRegExp = RegExp(r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]+$');

  void signupButton(bool userType) async {
    String apiUrl = '${Urls.apiUrl}user/signin_user';
    try {
      // 모든 필드가 비어있는 경우 처리
      if (idController.text.isEmpty ||
          pwdController.text.isEmpty ||
          pwdCheckController.text.isEmpty ||
          nicknameController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          classNumberController.text.isEmpty ||
          emailController.text.isEmpty) {
        Get.snackbar(
          '회원가입 실패',
          '모든 칸을 채워주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (!isEmailVerified) {
        Get.snackbar(
          '회원가입 실패',
          '이메일 인증을 완료해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 학번이 9자리 숫자가 아닐 경우 처리
      int? classNumber = int.tryParse(classNumberController.text);
      if (classNumber == null || classNumber.toString().length != 9) {
        Get.snackbar(
          '회원가입 실패',
          '학번은 9자리 숫자로 작성해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 비밀번호 일치 여부 확인
      if (pwdController.text != pwdCheckController.text) {
        Get.snackbar(
          '회원가입 실패',
          '비밀번호가 일치하지 않습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (emailController.text.length < 12 || emailController.text.substring(emailController.text.length - 12) != '@pusan.ac.kr') {
        Get.snackbar(
          '회원가입 실패',
          '이메일은 @pusan.ac.kr로 끝나야 합니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 아이디와 비밀번호 유효성 검사
      if (!idPwdRegExp.hasMatch(idController.text) || !idPwdRegExp.hasMatch(pwdController.text)) {
        Get.snackbar(
          '회원가입 실패',
          '아이디와 비밀번호는 영어와 숫자만 입력 가능합니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 전화번호 유효성 검사
      String? phoneNumber = phoneNumberController.text;
      if (phoneNumber.length != 11) {
        Get.snackbar(
          '회원가입 실패',
          '전화번호는 11자리 숫자로, 010######## 형식을 지켜주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": idController.text,
          "password": pwdController.text,
          "user_name": nicknameController.text,
          "phone_number": phoneNumberController.text,
          "student_address": classNumberController.text,
          "user_type": userType,
          "email": emailController.text,
          "brr_cash": 0,
        }),
      );

      if (response.statusCode == 200) {
        // 회원가입 성공 처리
        Get.snackbar(
          '회원가입 성공',
          '회원가입이 완료되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/login');
      } else if (response.statusCode == 409) {
        String bodyUtf8 = utf8.decode(response.bodyBytes);
        var responseJson = json.decode(bodyUtf8);
        String detailMessage = responseJson['detail'];
        Get.snackbar(
          '회원가입 실패',
          detailMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // 회원가입 실패 처리
        Get.snackbar(
          '회원가입 실패',
          '회원가입에 실패했습니다. 코드: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        '서버 연결에 실패했습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final emailCodeController = TextEditingController();

  Future<void> sendVerificationCode() async {
    String apiUrl = '${Urls.apiUrl}user/send_certification_number';
    try {
      if (emailController.text.isEmpty) {
        Get.snackbar(
          '전송 실패',
          '이메일을 입력해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      } else if (idController.text.isEmpty) {
        Get.snackbar(
          '전송 실패',
          '아이디를 입력해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      } else if (emailController.text.length < 12 || emailController.text.substring(emailController.text.length - 12) != '@pusan.ac.kr') {
        Get.snackbar(
          '전송 실패',
          '이메일은 @pusan.ac.kr로 끝나야 합니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": idController.text,
          "email": emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          '인증 코드 전송',
          '이메일로 인증 코드가 전송되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          '전송 실패',
          '인증 코드 전송에 실패했습니다. 다시 시도해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        '서버 연결에 실패했습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> checkVerificationCode() async {
    String apiUrl = '${Urls.apiUrl}user/check_number';
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": idController.text,
          "email": emailController.text,
          "number": emailCodeController.text,
        }),
      );

      if (response.statusCode == 200) {
        isEmailVerified = true;
        Get.snackbar(
          '인증 성공',
          '인증이 성공적으로 완료되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          '인증 실패',
          '인증 코드가 올바르지 않습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        '서버 연결에 실패했습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    idController.dispose();
    pwdController.dispose();
    pwdCheckController.dispose();
    nicknameController.dispose();
    phoneNumberController.dispose();
    classNumberController.dispose();
    emailController.dispose();
    emailCodeController.dispose();
    super.onClose();
  }
}
