import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:brr/constants/url.dart';

class SignUpPageController extends GetxController {
  final idController = TextEditingController();
  final pwdController = TextEditingController();
  final pwdCheckController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final classNumberController = TextEditingController();

  final RegExp idPwdRegExp = RegExp(r'^[a-zA-Z0-9]+$');
  final RegExp generalRegExp = RegExp(r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]+$');

  void signupButton() async {
    String apiUrl = '${Urls.apiUrl}user/';
    try {
      // 모든 필드가 비어있는 경우 처리
      if (idController.text.isEmpty || pwdController.text.isEmpty || pwdCheckController.text.isEmpty || phoneNumberController.text.isEmpty || classNumberController.text.isEmpty) {
        Get.snackbar(
          '회원가입 실패',
          '모든 칸을 채워주세요.',
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

      // 아이디와 비밀번호 유효성 검사
      if (!idPwdRegExp.hasMatch(idController.text) || !idPwdRegExp.hasMatch(pwdController.text)) {
        Get.snackbar(
          '회원가입 실패',
          '아이디와 비밀번호는 영어와 숫자만 입력 가능합니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 학번이 9자리숫자가 아닐 경우 처리
      int? classNumber = int.tryParse(classNumberController.text);
      if (classNumber == null || classNumber.toString().length != 9) {
        Get.snackbar(
          '회원가입 실패',
          '학번에는 9자리 숫자로 작성해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      int? phoneNumber = int.tryParse(phoneNumberController.text);
      if (phoneNumber == null || phoneNumber.toString().length != 11) {
        Get.snackbar(
          '회원가입 실패',
          '전화번호는 11자리 숫자로, 010########형식을 지켜주세요.',
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
          "phone": phoneNumberController.text,
          "class": classNumberController.text,
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
          '회원가입에 실패했습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to connect to the server: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    idController.dispose();
    pwdController.dispose();
    pwdCheckController.dispose();
    phoneNumberController.dispose();
    classNumberController.dispose();
    super.onClose();
  }
}
