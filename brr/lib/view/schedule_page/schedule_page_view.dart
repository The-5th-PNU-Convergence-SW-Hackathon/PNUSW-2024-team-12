import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
var kColumnLength = 16;
double kFirstColumnHeight = 20;
double kBoxSize = 44;
String dayDropDownValue = '';
String startTimeDropDownValue = '9:00';
String endTimeDropDownValue = '17:00';

List<String> generateTimeList(String strStartTime, String strEndTime) {
  List<String> listStartTime = strStartTime.split(":");
  List<String> listEndTime = strEndTime.split(":");

  int startHour = int.parse(listStartTime.first);
  int startMin = int.parse(listStartTime.last);
  int endHour = int.parse(listEndTime.first);
  int endMin = int.parse(listEndTime.last);

  List<String> timeList = [];

  for(int i = startHour; i < endHour; i++) {
    for(int j = 0; j < 60; j+=10) {
      if(i==startHour && j<startMin) { continue; }
      if(j==0) { timeList.add('$i:00'); continue; }
      timeList.add('$i:$j');
    }
  }

  if(endHour != 17) {
    for(int i = 0; i < endMin; i+=10) {
      if(i==0) { timeList.add('$endHour:00'); continue; }
      timeList.add('$endHour:$i');
    }
  } else { timeList.add('17:00'); }
  return timeList;
}

class SchedulePageView extends StatefulWidget {
  const SchedulePageView({Key? key}) : super(key: key);

  @override
  _SchedulePageViewState createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends State<SchedulePageView> {
  final List<Map<String, String>> _schedule = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 45.0),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '시간표 등록',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25.0),

                  Column(
                    children: [
                      Container(
                        height: kColumnLength / 2 * kBoxSize + 22,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            buildTimeColumn(),
                            ...buildDayColumn(0),
                            ...buildDayColumn(1),
                            ...buildDayColumn(2),
                            ...buildDayColumn(3),
                            ...buildDayColumn(4),
                            ...buildDayColumn(5),
                            ...buildDayColumn(6),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox( height: 24 ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        '시간 및 장소 추가',
                        style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600 ),
                      ),
                      IconButton(icon: const Icon(Icons.add), onPressed: (){}, color: const Color(0xff1479FF),),
                    ],
                  ),

                  const SizedBox( height: 12 ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      dayDropDown(),
                      const SizedBox( width: 30 ),
                      startTimeDropDown(),
                      const SizedBox( width: 8 ),
                      const SizedBox( width: 10, child: Divider( color: Colors.black, thickness: 1.0 ) ),
                      const SizedBox( width: 12 ),
                      endTimeDropDown(),


                    ],
                  ),

                ],
              )
          ),
        )
    );
  }

  Widget dayDropDown() {
    if (dayDropDownValue == "") {
      dayDropDownValue = '${week.first}요일';
    }

    return DropdownButton(
        value: dayDropDownValue,
        items: week.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: '$value요일',
            child: Text('$value요일', style: const TextStyle( fontSize: 13 ) ),
          );
        }).toList(),
        onChanged: (String? value){
          setState((){
            dayDropDownValue = value!;
          });
        });
  }

  Widget startTimeDropDown() {
    List<String> time = generateTimeList("9:00", endTimeDropDownValue);

    return DropdownButton(
        value: startTimeDropDownValue,
        items: time.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle( fontSize: 13 ) ),
          );
        }).toList(),
        onChanged: (String? value){
          setState((){
            startTimeDropDownValue = value!;
          });
        });
  }

  Widget endTimeDropDown() {
    List<String> time = generateTimeList(startTimeDropDownValue, "17:00");

    return DropdownButton(
        value: endTimeDropDownValue,
        items: time.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle( fontSize: 13 ) ),
          );
        }).toList(),
        onChanged: (String? value){
          setState((){
            endTimeDropDownValue = value!;
          });
        });
  }
}



Expanded buildTimeColumn() {
  return Expanded(
    child: Column(
      children: [
        SizedBox(
          height: kFirstColumnHeight,
        ),
        ...List.generate(
          kColumnLength,
              (index) {
            if (index % 2 == 0) {
              return const Divider(
                color: Colors.grey,
                height: 0,
              );
            }
            return SizedBox(
              height: kBoxSize,
              child: Center(child: Text('${index ~/ 2 + 9}', style: const TextStyle(fontSize: 10),)),
            );
          },
        ),
      ],
    ),
  );
}

List<Widget> buildDayColumn(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  week[index],
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}

