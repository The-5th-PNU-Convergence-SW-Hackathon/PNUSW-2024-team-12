import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brr/model/history_model.dart';
import '../../constants/url.dart';

class MyWrittenhistoryController extends GetxController {
  var historys = <History>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMyhistorys();
  }

  Future<void> loadMyhistorys() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      Get.offAllNamed('/login');
      return;
    }

    final url = '${Urls.apiUrl}history/load';
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData =
            jsonDecode(utf8.decode(response.bodyBytes)) as List;
        historys.value =
            responseData.map((history) => History.fromJson(history)).toList();
      } else {
        print('Failed to fetch historys: ${response.statusCode}');
        Get.snackbar('오류', '이용기록을 불러오는데 오류가 발생했습니다.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error occurred: $e');
      Get.snackbar('오류', '네트워크 오류가 발생했습니다.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deletehistory(int historyId, int index) async {
    final url = '${Urls.apiUrl}historys/$historyId';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        historys.removeAt(index);
        Get.snackbar('성공', '게시글 삭제에 성공했습니다.',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print('Failed to delete history: ${response.statusCode}');
        Get.snackbar('오류', '게시글 삭제에 실패했습니다.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error occurred: $e');
      Get.snackbar('오류', '네트워크 오류가 발생했습니다.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}