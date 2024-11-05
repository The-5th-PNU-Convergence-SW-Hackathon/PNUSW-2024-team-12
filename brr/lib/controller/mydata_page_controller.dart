import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brr/model/info_model.dart';

class MyPageController extends GetxController {
  final pwController = TextEditingController();
  final newPwController = TextEditingController();
  final newPwCheckController = TextEditingController();

  var nickname = ''.obs;
  var car_num = ''.obs;
  var car_model = ''.obs;
  var id = ''.obs;

  @override
  void onInit() {
    super.onInit();
    showInfo();
  }

  Future<void> deleteTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  Future<void> logout() async {
    await deleteTokens();
    Get.offAllNamed('/login');
  }

  Future<void> showInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    String apiUrl = '${Urls.apiUrl}taxi/taxi_main';
    try {
      var response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        String bodyUtf8 = utf8.decode(response.bodyBytes);
        var data = mypage_info.fromJson(json.decode(bodyUtf8));
        nickname.value = data.driver_name;
        car_num.value = data.car_num;
        car_model.value = data.car_model;
        id.value = data.id;
      } else {}
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to connect to the server',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void changePwdButton() async {
    String apiUrl = '${Urls.apiUrl}user/modify_pw';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        Get.snackbar(
          'Error',
          '로그인 토큰이 없습니다. 다시 로그인 해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      if (pwController.text.isEmpty || newPwController.text.isEmpty || newPwCheckController.text.isEmpty) {
        Get.snackbar(
          '비밀번호 변경 실패',
          '모든 칸을 채워주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (newPwController.text != newPwCheckController.text) {
        Get.snackbar(
          '비밀번호 변경 실패',
          '새 비밀번호가 일치하지 않습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final RegExp idPwdRegExp = RegExp(r'^[a-zA-Z0-9]+$');
      if (!idPwdRegExp.hasMatch(newPwController.text)) {
        Get.snackbar(
          '비밀번호 변경 실패',
          '비밀번호는 영어와 숫자만 입력 가능합니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      var response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
        "password": pwController.text,
        "new_password": newPwController.text,
      }),
      );

      if (response.statusCode == 200) {
        // 비밀번호 변경 성공 처리
        Get.dialog(
    Dialog(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                backgroundColor: Color(0xFF1479FF),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Get.offAllNamed("/mypage");  // "/mypage"로 이동
              },
              child: const Text('확인', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ],
        ),
      ),
    ),
  );
      } else {
        // 비밀번호 변경 실패 처리
        Get.snackbar(
          '비밀번호 변경 실패',
          '비밀번호 변경에 실패했습니다. ${response.body}',
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
}
