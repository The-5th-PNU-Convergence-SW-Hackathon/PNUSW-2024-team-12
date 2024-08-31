import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brr/constants/url.dart';
import 'dart:convert';

class DriverAcceptController extends GetxController {
  var callInfo = {}.obs; 

  Future<void> fetchCallInfo(int matchingId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      Get.offAllNamed('/login');
      return;
    }

    String apiUrl = '${Urls.apiUrl}taxi/call_info?matching_id=$matchingId';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        callInfo.value = json.decode(decodedBody);
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch call info. Please try again. Status Code: ${response.statusCode}',
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
