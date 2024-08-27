import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:brr/controller/add_match_list_controller.dart';
import 'package:table_calendar/table_calendar.dart';


List<String> generateHourList() {
  List<String> hourList = [];
  for (int i = 0; i < 24; i++) {
    if ( i < 10 ) { hourList.add('0$i'); }
    else { hourList.add('$i'); }
  }
  return hourList;
}

List<String> generateMinList() {
  List<String> minList = [];
  for (int i = 0; i <i 60; i++) {
    if ( i < 10 ) { minList.add('0$i'); }
    else { minList.add('$i'); }
  }
  return minList;
}

class ReservationMatchingPageView extends StatelessWidget {
  const ReservationMatchingPageView({super.key});

  @override
  Widget build(BuildContext context) {

    final LocationController locationController = Get.put(LocationController());

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.blueGrey,
            child: const Center(
              child: Image(
                image: AssetImage('assets/images/map.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.12,
            maxChildSize: 0.55,
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
                              const SizedBox(height: 28),
                              const Text('택시를 호출할 시간을 설정해주세요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  )),
                              const SizedBox(height: 32),
                              Container(
                                decoration: const BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(20)), color: Color(0xffF3F8FF) ),
                                height: 277,
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    SizedBox( width: 216, child: buildTableCalendar() ),

                                  ],
                                )
                              )
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
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/writelocation');
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
    )));
  }

  Widget buildTableCalendar() {
    return TableCalendar(
      locale: 'ko-KR',
      // daysOfWeekHeight: 30,
      rowHeight: 28,
      focusedDay: DateTime.now(),
      firstDay: DateTime.now(),
      lastDay: DateTime(2024,12,31),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronVisible: false,
        rightChevronVisible: false
      ),


      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          switch(day.weekday) {
            case 1:
              return const Center( child: Text('Mo') );
            case 2:
              return const Center( child: Text('Tu') );
            case 3:
              return const Center( child: Text('We') );
            case 4:
              return const Center( child: Text('Th') );
            case 5:
              return const Center( child: Text('Fr') );
            case 6:
              return const Center( child: Text('Sa') );
            case 7:
              return const Center( child: Text('Su') );
          }
        }
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
}
