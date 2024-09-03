import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:brr/controller/add_match_list_controller.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
String hourDropDownValue = DateTime.now().hour < 10 ? '0${DateTime.now().hour}' : '${DateTime.now().hour}';
String minDropDownValue = DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : '${DateTime.now().minute}';
DateTime selectedDateTime = DateTime.now();

List<String> generateHourList() {
  List<String> hourList = [];
  for (int i = 0; i < 24; i++) {
    if (i < 10) {
      hourList.add('0$i');
    } else {
      hourList.add('$i');
    }
  }
  return hourList;
}

List<String> generateMinList() {
  List<String> minList = [];
  for (int i = 0; i < 60; i++) {
    if (i < 10) {
      minList.add('0$i');
    } else {
      minList.add('$i');
    }
  }
  return minList;
}

class ReservationMatchingPageView extends StatefulWidget {
  const ReservationMatchingPageView({super.key});

  @override
  State<ReservationMatchingPageView> createState() => _ReservationMatchingPageViewState();
}

class _ReservationMatchingPageViewState extends State<ReservationMatchingPageView> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
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
    final LocationController locationController = Get.put(LocationController());
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
            initialChildSize: 0.6,
            minChildSize: 0.12,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                              ),
                              const SizedBox(height: 15),
                              const Text('택시를 호출할 시간을 설정해주세요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  )),
                              const SizedBox(height: 15),
                              Container(
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Color(0xffF3F8FF)),
                                  height: 310,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      SizedBox(width: 400, child: buildTableCalendar()),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          hourDropDown(),
                                          const SizedBox(width: 8),
                                          const Text(":"),
                                          const SizedBox(width: 8),
                                          minDropDown(),
                                        ],
                                      )
                                    ],
                                  )),
                              const SizedBox(height: 10),
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
                                        addMatchListController.isReservation.value = true; // 예약 매칭 설정

                                        final DateTime selectedTime = DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          int.parse(hourDropDownValue),
                                          int.parse(minDropDownValue),
                                        );

                                        selectedDateTime = selectedTime;
                                        addMatchListController.selectedDateTime.value = selectedDateTime;

                                        Get.toNamed('/matching');
                                      },
                                      child: const Text('다음 단계로 넘어가기',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ))))
                            ],
                          )),
                    ],
                  ));
            }),
        Positioned(
          top: 50.0,
          left: 30.0,
          child: Row(
            children: [
              gobackButton(),
            ],
          )
        )
      ],
    )));
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
      selectedDateTime = selectedDate;
    });
  }

  Widget buildTableCalendar() {
    return TableCalendar(
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) {
        return isSameDay(selectedDate, date);
      },
      focusedDay: selectedDate,
      locale: 'ko-KR',
      // daysOfWeekHeight: 30,
      rowHeight: 35,
      firstDay: DateTime.now(),
      lastDay: DateTime(2024, 12, 31),
      headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true, leftChevronVisible: true, rightChevronVisible: true),
      calendarStyle: const CalendarStyle(
        defaultTextStyle: TextStyle(fontSize: 13),
        selectedDecoration: BoxDecoration(
          color: Colors.blue, // 선택된 날짜의 배경색
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.red, // 오늘 날짜의 배경색
          shape: BoxShape.circle,
        ),
      ),

      calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
        switch (day.weekday) {
          case 1:
            return const Center(child: Text('Mo'));
          case 2:
            return const Center(child: Text('Tu'));
          case 3:
            return const Center(child: Text('We'));
          case 4:
            return const Center(child: Text('Th'));
          case 5:
            return const Center(child: Text('Fr'));
          case 6:
            return const Center(child: Text('Sa'));
          case 7:
            return const Center(child: Text('Su'));
        }
        return null;
      }),
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

  Widget hourDropDown() {
    List<String> time = generateHourList();

    return DropdownButton(
        value: hourDropDownValue,
        items: time.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            hourDropDownValue = value!;
          });
        });
  }

  Widget minDropDown() {
    List<String> time = generateMinList();

    return DropdownButton(
        value: minDropDownValue,
        items: time.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            minDropDownValue = value!;
          });
        });
  }
}
