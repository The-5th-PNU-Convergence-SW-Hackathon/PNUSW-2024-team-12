import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/join_match_controller.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:brr/controller/add_match_list_controller.dart';
import 'dart:convert';

class CompleteMatchingViewPage extends StatefulWidget {
  const CompleteMatchingViewPage({super.key});

  @override
  _CompleteMatchingViewPageState createState() =>
      _CompleteMatchingViewPageState();
}

class _CompleteMatchingViewPageState extends State<CompleteMatchingViewPage> {
  late NaverMapController _mapController;
  final JoinMatchController controller = Get.put(JoinMatchController());
  final AddMatchListController controllerAdd =
      Get.put(AddMatchListController());

  @override
  void initState() {
    super.initState();
    setupWebSocketListener(); // WebSocket 메시지 수신을 설정합니다.
  }

  void setupWebSocketListener() {
    controllerAdd.currentMemberStatus.listen((status) {
      if (status == '운행완료') {
        // "운행완료" 메시지를 받으면 다른 페이지로 이동합니다.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/ridecomplete');
        });
      }
    });
    controller.currentMemberCount.listen((status) {
      if (status == '운행완료') {
        // "운행완료" 메시지를 받으면 다른 페이지로 이동합니다.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/ridecomplete');
        });
      }
    });
  }

  List<NLatLng> convertToLatLng(List<Map<String, dynamic>> pathData) {
    return pathData.map((point) {
      return NLatLng(point['lat'], point['lng']);
    }).toList();
  }

  void _updateMap(
      List<List<NLatLng>> latLngLists, NLatLng start, NLatLng end) async {
    await _mapController.clearOverlays();

    final startMarker = NMarker(
      id: "startMarker",
      position: start,
      iconTintColor: Colors.red,
    );
    await _mapController.addOverlay(startMarker);

    final endMarker = NMarker(
      id: "endMarker",
      position: end,
      iconTintColor: Colors.green,
    );
    await _mapController.addOverlay(endMarker);

    if (latLngLists.isNotEmpty) {
      Set<NAddableOverlay> overlays = {};

      for (var latLngList in latLngLists) {
        final multipartPathOverlay = NMultipartPathOverlay(
          id: DateTime.now().toIso8601String(),
          paths: [
            NMultipartPath(coords: latLngList),
          ],
          width: 5,
        );
        overlays.add(multipartPathOverlay);
      }

      await _mapController.addOverlayAll(overlays);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = Get.arguments;

    final taxiId = data['taxi_id'];
    final driverName = data['driver_name'];
    final carNum = data['car_num'];
    final phoneNumber = data['phone_number'];
    final depart = data['depart'];
    final dest = data['dest'];
    final String pathString = data['path'];
    final List<Map<String, dynamic>> pathData =
        List<Map<String, dynamic>>.from(jsonDecode(pathString));
    final List<NLatLng> latLngList = convertToLatLng(pathData);

    final start = latLngList.first;
    final end = latLngList.last;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: start,
                    zoom: 16,
                    bearing: 0,
                    tilt: 0,
                  ),
                  locale: const Locale('kr'),
                  locationButtonEnable: true,
                ),
                onMapReady: (controller) {
                  _mapController = controller;
                  _updateMap([latLngList], start, end);
                },
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.24,
              minChildSize: 0.12,
              maxChildSize: 0.7,
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                driverCard(driverName, carNum),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        circleContainer,
                                        const SizedBox(width: 5),
                                        const Text(
                                          "약 3분 후 도착",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        circleContainer,
                                        const SizedBox(width: 5),
                                        Text(
                                          "목적지 $dest",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            contactRow(
                                "기사님께 연락하기...",
                                const Icon(Icons.phone,
                                    color: Color(0xFF1479FF), size: 20)),
                            const SizedBox(height: 30),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "매칭 완료",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "안선주 이지헌",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            contactRow(
                                "매칭된 사람들과 연락하기...",
                                const Icon(Icons.chat,
                                    color: Color(0xFF1479FF), size: 20)),
                            const SizedBox(height: 30),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "예상 결제 비용",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 10),
                                        Container(
                                          width: 200,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                        ),
                                      ]),
                                ]),
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
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.1),
                    ),
                    child: SizedBox(
                      width: 270.0,
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          locationRow(circleContainer, '출발지', depart),
                          const SizedBox(height: 5.0),
                          locationRow(rectangularContainer, '도착지', dest),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget driverCard(String driverName, String carNum) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF1479FF),
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    carNum,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget contactRow(String title, Widget icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Get.toNamed('/chating');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const Icon(
                  Icons.near_me,
                  color: Color(0xFF1479FF),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: icon,
          ),
        ),
      ],
    );
  }
}
