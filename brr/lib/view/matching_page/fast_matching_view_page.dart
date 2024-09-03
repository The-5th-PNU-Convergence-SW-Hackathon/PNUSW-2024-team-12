import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:brr/controller/add_match_list_controller.dart';
import 'package:intl/intl.dart';
class MatchingPageView extends StatefulWidget {
  const MatchingPageView({super.key});

  @override
  _MatchingPageViewState createState() => _MatchingPageViewState();
}

class _MatchingPageViewState extends State<MatchingPageView> {
  late NaverMapController _mapController;
  final LocationController locationController = Get.put(LocationController());

  void _updateMap() async {
    await _mapController.clearOverlays();

    if (locationController.startLatitude.value != 0.0 &&
        locationController.startLongitude.value != 0.0) {
      final startMarker = NMarker(
        id: "startMarker",
        position: NLatLng(locationController.startLatitude.value, locationController.startLongitude.value),
        iconTintColor: Colors.yellow,
      );
      await _mapController.addOverlay(startMarker);
    }
    final cameraUpdate = NCameraUpdate.withParams(
      target: NLatLng(locationController.startLatitude.value != 0.0 ? locationController.startLatitude.value :35.2339681,
         locationController.startLongitude.value != 0.0 ? locationController.startLongitude.value :129.0806855 ),
      zoom: 16,
      bearing: 0,
    );
    await _mapController.updateCamera(cameraUpdate);

    if (locationController.endLatitude.value != 0.0 &&
        locationController.endLongitude.value != 0.0) {
      final endMarker = NMarker(
        id: "endMarker",
        position: NLatLng(locationController.endLatitude.value, locationController.endLongitude.value),
        iconTintColor: Colors.green,
      );
      await _mapController.addOverlay(endMarker);
    }

    if (locationController.pathCoordinates.isNotEmpty) {
      Set<NAddableOverlay> overlays = {};

      for (var path in locationController.pathCoordinates) {
        final multipartPathOverlay = NMultipartPathOverlay(
          id: DateTime.now().toIso8601String(),
          paths: [
            NMultipartPath(coords: path),
          ],
        );
        overlays.add(multipartPathOverlay);
      }

      await _mapController.addOverlayAll(overlays);
    }

    setState(() {});
  }
  
  String _getDurationInMinutes(double durationInSeconds) {
    int minutes = (durationInSeconds / 60000).round();
    return minutes.toString();
  }

  @override
  Widget build(BuildContext context) {
    final  startLat = locationController.startLatitude.value;
    final  startLong = locationController.startLongitude.value;
    print("$startLat, $startLong");
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(35.2339681, 129.0806855), 
                    zoom: 15,
                    bearing: 0,
                    tilt: 0,
                  ),
                  locale: const Locale('kr'),
                  locationButtonEnable: true,
                ),
                onMapReady: (controller) {
                  _mapController = controller;
                },
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.57,
              minChildSize: 0.12,
              maxChildSize: 0.65,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Obx(() => Text(
                                  '약 ${_getDurationInMinutes(locationController.duration.value)}분 소요',
                                  style: const TextStyle(fontSize: 12),
                                )),
                            const SizedBox(height: 15),
                            const Divider(color: Colors.grey, thickness: 1),
                            const SizedBox(height: 15),
                            const Text(
                              '매칭 할 인원을 선택하세요',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _matchpeopleButton('2인 이상', 2),
                                _matchpeopleButton('3인 이상', 3),
                                _matchpeopleButton('4인 ', 4),
                                _matchpeopleButton('상관없음', 1),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Divider(color: Colors.grey, thickness: 1),
                            const SizedBox(height: 15),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '  결제 수단',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                                  
                                 Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '라이언 치즈 체크카드',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          'NH농협카드',
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        
                                      ],
                                    ),
                                  ),]),
                                
                    ]),
                                
                              
                            
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1479FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  final AddMatchListController addMatchListController = Get.put(AddMatchListController());

                                  if (addMatchListController.selectedMinMember.value == 0 &&
                                      locationController.startLocation.value == '' &&
                                      locationController.endLocation.value == '') {
                                    Get.snackbar('Error', '매칭 조건(출발지/도착지/인원)을 모두 채워주세요.');
                                  } else if (locationController.startLocation.value == '' ||
                                      locationController.endLocation.value == '') {
                                    Get.snackbar('Error', '출발지와 도착지를 채워주세요.');
                                  } else if (addMatchListController.selectedMinMember.value == 0) {
                                    Get.snackbar('Error', '매칭 할 인원을 선택해주세요.');
                                  } else {
                                    addMatchListController.sendMatchData(addMatchListController.selectedMinMember.value);
                                    Get.toNamed('/matchloading');
                                  }
                                },
                                child: const Text(
                                  '매칭 시작하기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              top: 50.0,
              left: 30.0,
              child: Row(
                children: [
                  goBackButton(),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Get.toNamed('/writelocation');
                      if (result == true) {
                        await locationController.getRoute();
                        _updateMap(); // 먼저 맵을 빌드하고 경로를 저장한 후 다시 맵을 빌드
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.1),
                    ),
                    child: SizedBox(
                      width: 270.0,
                      height: 70,
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              locationRow(circleContainer, '출발지', locationController.startLocation.value.isEmpty ? '' : locationController.startLocation.value),
                              const SizedBox(height: 5.0),
                              locationRow(rectangularContainer, '도착지', locationController.endLocation.value.isEmpty ? '' : locationController.endLocation.value),
                            ],
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _matchpeopleButton(String text, int minMember) {
    final AddMatchListController addMatchListController = Get.put(AddMatchListController());

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(
        () => SizedBox(
          width: 80,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: addMatchListController.selectedMinMember.value == minMember ? Color(0xFF1479FF) : Colors.white,
              backgroundColor: addMatchListController.selectedMinMember.value == minMember ? Colors.white : Color(0xFF1479FF),
              side: addMatchListController.selectedMinMember.value == minMember ? const BorderSide(color: Color(0xFF1479FF), width: 2) : BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              if (addMatchListController.selectedMinMember.value == minMember) {
                addMatchListController.selectedMinMember.value = 0;
              } else {
                addMatchListController.selectedMinMember.value = minMember;
              }
            },
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: addMatchListController.selectedMinMember.value == minMember ? Color(0xFF1479FF) : Colors.white,
                    ),
                  ),
                  Text(
                    _calculateFare(minMember),
                    style: TextStyle(
                      fontSize: 12,
                      color: addMatchListController.selectedMinMember.value == minMember ? Color(0xFF1479FF) : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _calculateFare(int minMember) {
    double baseFare = locationController.taxiFare.value;

    final formatter = NumberFormat(',###,###');

    switch (minMember) {
      case 2:
        return '~ ${formatter.format((baseFare / 2).round())}원';
      case 3:
        return '~ ${formatter.format((baseFare / 3).round())}원';
      case 4:
        return ' ${formatter.format((baseFare / 4).round())}원';
      default:
        return '~ ${formatter.format((baseFare / 1).round())}원';
    }
  }

  Widget locationRow(Widget icon, String title, String subtitle) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 10.0),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 5.0),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget goBackButton() {
    return SizedBox(
      width: 35.0,
      height: 35.0,
      child: FloatingActionButton(
        onPressed: () {
          final AddMatchListController addMatchListController = Get.find<AddMatchListController>();
          final LocationController locationController = Get.find<LocationController>();

          addMatchListController.selectedMinMember.value = 0;
          locationController.startLocation.value = '';
          locationController.endLocation.value = '';
          Get.back();
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1479FF),
        elevation: 4.0,
        child: const Icon(
          Icons.arrow_back,
          size: 20.0,
        ),
      ),
    );
  }
}
