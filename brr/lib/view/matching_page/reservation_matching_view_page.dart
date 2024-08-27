import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:table_calendar/table_calendar.dart';

String hourDropDownValue = DateTime.now().hour < 10 ? '0${DateTime.now().hour}' : '${DateTime.now().hour}';
String minDropDownValue = DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : '${DateTime.now().minute}';
DateTime selectedDateTime = DateTime.now();

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
  for (int i = 0; i < 60; i++) {
    if ( i < 10 ) { minList.add('0$i'); }
    else { minList.add('$i'); }
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
                                    SizedBox( width: 400, child: buildTableCalendar() ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        hourDropDown(),
                                        const SizedBox( width: 8 ),
                                        const Text(":"),
                                        const SizedBox( width: 8 ),
                                        minDropDown(),
                                      ],
                                    )
                                  ],
                                )
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.toNamed('/writelocation');
                                  },
                                  child: const Text(
                                    '다음 단계로 넘어가기',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    )
                                  )
                                )
                              )
                            ],
                          )
                       ),
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
      rowHeight: 28,
      firstDay: DateTime.now(),
      lastDay: DateTime(2024,12,31),
      headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronVisible: true,
          rightChevronVisible: true
      ),
      calendarStyle: const CalendarStyle( defaultTextStyle: TextStyle( fontSize: 13 ) ),


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
