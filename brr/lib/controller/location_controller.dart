import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationController extends GetxController {
  var startLocation = ''.obs;
  var endLocation = ''.obs;

  // 위도와 경도를 저장할 변수
  var startLatitude = 0.0.obs;
  var startLongitude = 0.0.obs;
  var endLatitude = 0.0.obs;
  var endLongitude = 0.0.obs;

  // 경로 좌표를 저장할 리스트
  var pathCoordinates = <List<NLatLng>>[].obs;  
  var distance = 0.0.obs; // 거리 (미터)
  var duration = 0.0.obs; // 소요 시간 (초)
  var taxiFare = 0.0.obs; // 예상 택시 요금 (원)

  // 네이버 API 키와 엔드포인트
  final String naverApiKey = dotenv.env['Map_Api_Client_Id']!;
  final String naverApiSecret = dotenv.env['Map_Api_Secret_Id']!;
  final String searchApiKey = dotenv.env['Search_Api_Key']!;
  final String searchApiSecret = dotenv.env['Search_Api_Secret_Id']!;
  final String geocodingUrl = 'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode';
  final String direction5Url = 'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving';
  final String searchUrl = 'https://openapi.naver.com/v1/search/local.json';

  // 위치 설정 및 경로 계산을 한 번에 처리하는 함수
  Future<bool> setLocations(String start, String end) async {
    try {
      startLocation.value = start;
      Map<String, double>? startCoordinates = await _getCoordinatesFromLocation(start);
      if (startCoordinates != null) {
        startLatitude.value = startCoordinates['lat']!;
        startLongitude.value = startCoordinates['lng']!;
      } else {
        print("출발지 좌표 설정 실패");
        return false;
      }


      endLocation.value = end;
      Map<String, double>? endCoordinates = await _getCoordinatesFromLocation(end);
      if (endCoordinates != null) {
        endLatitude.value = endCoordinates['lat']!;
        endLongitude.value = endCoordinates['lng']!;
      } else {
        print("도착지 좌표 설정 실패");
        return false;
      }

      await getRoute();
      return true;
    } catch (e) {
      print("위치 설정 및 경로 계산 오류: $e");
      return false;
    }
  }

  void updateStartLocation(String location) async {
    startLocation.value = location;
    Map<String, double>? coordinates = await _getCoordinatesFromLocation(location);
    if (coordinates != null) {
      startLatitude.value = coordinates['lat']!;
      startLongitude.value = coordinates['lng']!;

      if (endLatitude.value != 0.0 && endLongitude.value != 0.0) {
        await getRoute();
      }
    } else {
      print("시작지점 설정 실패");
    }
  }

  void updateEndLocation(String location) async {
    endLocation.value = location;
    Map<String, double>? coordinates = await _getCoordinatesFromLocation(location);
    if (coordinates != null) {
      endLatitude.value = coordinates['lat']!;
      endLongitude.value = coordinates['lng']!;

      if (startLatitude.value != 0.0 && startLongitude.value != 0.0) {
        await getRoute();
      }
    } else {
      print("종료지점 설정 실패");
    }
  }

  Future<Map<String, double>?> _getCoordinatesFromLocation(String location) async {
    try {
      var response = await http.get(
        Uri.parse('$searchUrl?query=$location'),
        headers: {
          'X-Naver-Client-Id': searchApiKey,
          'X-Naver-Client-Secret': searchApiSecret
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        if (data['items'] != null && data['items'].isNotEmpty) {
          var item = data['items'][0];
          double longitude = double.parse(item['mapx']) * 0.0000001;
          double latitude = double.parse(item['mapy']) * 0.0000001;
          return {
            'lat': latitude,
            'lng': longitude,
          };
        } else {
          print("지역에 대한 정보가 없음");
        }
      } else {
        print("좌표설정 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("좌표설정 오류: $e");
    }
    return null;
  }

  Future<void> getRoute() async {
    if (startLatitude.value == 0.0 || startLongitude.value == 0.0 ||
        endLatitude.value == 0.0 || endLongitude.value == 0.0) {
      return;
    }

    try {
      var response = await http.get(
        Uri.parse(
          '$direction5Url?start=${startLongitude.value},${startLatitude.value}&goal=${endLongitude.value},${endLatitude.value}&option=trafast'  // 트래픽 빠른 옵션 사용
        ),
        headers: {
          'X-NCP-APIGW-API-KEY-ID': naverApiKey,
          'X-NCP-APIGW-API-KEY': naverApiSecret,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['route'] != null && data['route']['trafast'] != null) {
          var route = data['route']['trafast'][0];

          // 경로 좌표 저장
          pathCoordinates.clear();
          var path = route['path'];
          List<NLatLng> part = [];
          for (var point in path) {
            double latitude = point[1];  // 위도
            double longitude = point[0]; // 경도
            part.add(NLatLng(latitude, longitude));
          }
          pathCoordinates.add(part);

          // 거리, 소요시간, 택시 요금 저장
          distance.value = route['summary']['distance'].toDouble();
          duration.value = route['summary']['duration'].toDouble();  // 소요 시간을 초 단위로 저장
          taxiFare.value = route['summary']['taxiFare'].toDouble();

          print("경로 좌표, 거리, 소요시간, 택시 요금 저장 완료");
          print("거리 ${distance.value}, 소요시간 ${duration.value}, 택시예상요금 ${taxiFare.value}");
        } else {
          print("길이 존재하지 않음");
        }
      } else {
        print('경로설정에 실패했음: ${response.statusCode}');
      }
    } catch (e) {
      print('오류가 발생했습니다. $e');
    }
  }

  // 위치 정보 초기화
  void clearLocations() {
    startLocation.value = '';
    endLocation.value = '';
    startLatitude.value = 0.0;
    startLongitude.value = 0.0;
    endLatitude.value = 0.0;
    endLongitude.value = 0.0;
    pathCoordinates.clear();
  }

  String convertPathToJson(List<NLatLng> path) {
  List<Map<String, double>> jsonPath = path
      .map((point) => {'lat': point.latitude, 'lng': point.longitude})
      .toList();
  return json.encode(jsonPath);
}
}
