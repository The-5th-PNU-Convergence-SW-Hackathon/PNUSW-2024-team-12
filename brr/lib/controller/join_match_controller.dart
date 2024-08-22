import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brr/model/join_match_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brr/constants/url.dart';
import 'dart:io';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class JoinMatchController extends GetxController {
  var joinedMatches = <JoinMatchModel>[].obs;
  late WebSocketChannel channel;
  var currentMemberCount = 0.obs;

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

          // 매칭에 성공하면 WebSocket 연결을 설정합니다.
          connectToLobby(id);

          Get.snackbar('Success', '매칭에 성공했습니다.', snackPosition: SnackPosition.BOTTOM);
          Get.offAllNamed('/joinloading');
        }
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

  // WebSocket 연결 설정
  void connectToLobby(int lobbyId) {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://${Urls.wsUrl}matching/lobbies/$lobbyId/ws'),
    );

    // 서버로부터 오는 메시지를 처리
    channel.stream.listen((message) {
      currentMemberCount.value = int.parse(message); // 받은 메시지를 인원 수로 변환
    }, onError: (error) {
      Get.snackbar('Error', 'WebSocket 연결에 문제가 발생했습니다.', snackPosition: SnackPosition.BOTTOM);
    });
  }

  // WebSocket 연결 해제
  void disconnectFromLobby() {
    channel.sink.close();
  }

  @override
  void onClose() {
    disconnectFromLobby();
    super.onClose();
  }
}
