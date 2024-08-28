import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brr/constants/url.dart';

class DriverAcceptController extends GetxController {
  Future<void> acceptCall(int matchingId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      Get.offAllNamed('/login');
      return;
    }

    String apiUrl = '${Urls.apiUrl}taxi/catch_call?matching_id=$matchingId';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Call accepted successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
        // 필요시 UI 업데이트나 화면 전환
      } else {
        Get.snackbar(
          'Error',
          'Failed to accept call. Please try again. Status Code: ${response.statusCode}',
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
