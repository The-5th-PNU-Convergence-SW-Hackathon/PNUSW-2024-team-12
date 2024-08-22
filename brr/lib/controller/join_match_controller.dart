import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brr/model/join_match_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brr/constants/url.dart';
import 'dart:io';
import 'dart:async';

class JoinMatchController extends GetxController {
  var joinedMatches = <JoinMatchModel>[].obs;

  Future<void> joinMatch(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        Get.offAllNamed('/login');
        return;
      }

      final url = '${Urls.apiUrl}matching/lobbies/join';
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      };
      final body = utf8.encode(json.encode({'id': id}));

      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));

        if (responseData is Map<String, dynamic>) {
          JoinMatchModel match = JoinMatchModel.fromJson(responseData);
          joinedMatches.add(match);
        }

        Get.snackbar('Success', '매칭에 성공했습니다.', snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/joinloading');
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/login');
      } else if (response.statusCode == 404) {
        Get.snackbar('Error', '매칭을 찾을 수 없습니다.', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', '매칭에 실패했습니다. 상태 코드: ${response.statusCode}', snackPosition: SnackPosition.BOTTOM);
      }
    } on SocketException {
      Get.snackbar('Error', '네트워크 연결을 확인해주세요.', snackPosition: SnackPosition.BOTTOM);
    } on TimeoutException {
      Get.snackbar('Error', '서버 응답 시간이 초과되었습니다.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print('오류: $e');
      Get.snackbar('Error', '예기치 않은 오류가 발생했습니다: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
