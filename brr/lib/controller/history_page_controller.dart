import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brr/model/history_model.dart';
import '../../constants/url.dart';

class HistoryPageController extends GetxController {
  var historys = <History>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMyHistorys();
  }

  Future<void> loadMyHistorys() async {
    try {
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

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
        
        // 데이터가 리스트인지 확인하고 변환
        if (responseData is List) {
          historys.value = responseData.map((history) => History.fromJson(history)).toList();
        } else {
          throw Exception("Unexpected response format");
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/login');
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
}
