import 'package:get/get.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brr/constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMatchListController extends GetxController {
  final LocationController locationController = Get.find<LocationController>();

  Future<void> sendMatchData(int minMember) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      Get.offAllNamed('/login');
      return;
    }

    const int matchingType = 0;
    final boardingTime = DateTime.now().toString();
    final startLocation = locationController.startLocation.value;
    final endLocation = locationController.endLocation.value;

    final data = {
      "matching_type": matchingType,
      "boarding_time": boardingTime,
      "depart": startLocation.isEmpty ? '' : startLocation,
      "dest": endLocation.isEmpty ? '' : endLocation,
      "min_member": minMember,
    };

    final url = '${Urls.apiUrl}matching/create';
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Match data sent successfully');
      } else {
        print('Failed to send match data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while sending match data: $e');
    }
  }
}
