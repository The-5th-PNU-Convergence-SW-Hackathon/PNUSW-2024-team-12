import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

// Global Variables
List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
var kColumnLength = 16;
double kFirstColumnHeight = 20;
double kBoxSize = 44;
String dayDropDownValue = '';
String startTimeDropDownValue = '9:00';
String endTimeDropDownValue = '17:00';
String locationValue = '';
String lectureValue = '';

final Uuid uuid = Uuid();

Future<void> saveLectureCount(int count) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('lectureCount', count);
}

Future<int?> getLectureCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? myInt = prefs.getInt('lectureCount');
  return myInt;
}

Future<void> saveSchedule(String id, Map<String, dynamic> jsonData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(jsonData);
  await prefs.setString(id, jsonString);
}

Future<Map<String, dynamic>> getSchedule(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> jsonData = {};
  String? jsonString = prefs.getString(id);
  if (jsonString != null) {
    jsonData = jsonDecode(jsonString);
  }
  return jsonData;
}

Future<void> delSchedule(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(id);
}

Future<List<String>> getAllScheduleIds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('scheduleIds') ?? [];
}

Future<void> saveScheduleId(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> ids = await getAllScheduleIds();
  ids.add(id);
  await prefs.setStringList('scheduleIds', ids);
}

Future<void> delScheduleId(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> ids = await getAllScheduleIds();
  ids.remove(id);
  await prefs.setStringList('scheduleIds', ids);
}

List<String> generateTimeList(String strStartTime, String strEndTime) {
  List<String> listStartTime = strStartTime.split(":");
  List<String> listEndTime = strEndTime.split(":");

  int startHour = int.parse(listStartTime.first);
  int startMin = int.parse(listStartTime.last);
  int endHour = int.parse(listEndTime.first);
  int endMin = int.parse(listEndTime.last);

  List<String> timeList = [];

  for (int i = startHour; i < endHour; i++) {
    for (int j = 0; j < 60; j += 10) {
      if (i == startHour && j < startMin) { continue; }
      if (j == 0) { timeList.add('$i:00'); continue; }
      timeList.add('$i:$j');
    }
  }

  if (endHour != 17) {
    for (int i = 0; i < endMin; i += 10) {
      if (i == 0) { timeList.add('$endHour:00'); continue; }
      timeList.add('$endHour:$i');
    }
  } else { timeList.add('17:00'); }
  return timeList;
}

double calculateTopPosition(String startTime) {
  List<String> timeParts = startTime.split(":");
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  return (hour - 9) * kBoxSize + (minute / 60) * kBoxSize + kFirstColumnHeight;
}

double calculateBoxHeight(String startTime, String endTime) {
  List<String> startParts = startTime.split(":");
  int startHour = int.parse(startParts[0]);
  int startMinute = int.parse(startParts[1]);

  List<String> endParts = endTime.split(":");
  int endHour = int.parse(endParts[0]);
  int endMinute = int.parse(endParts[1]);

  double hours = (endHour + endMinute / 60) - (startHour + startMinute / 60);
  return hours * kBoxSize;
}

class SchedulePageView extends StatefulWidget {
  const SchedulePageView({Key? key}) : super(key: key);

  @override
  _SchedulePageViewState createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends State<SchedulePageView> {
  final TextEditingController _lectureTextController = TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();

  List<Map<String, dynamic>> _scheduleBoxes = [];

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
            ),
            // Add Positioned boxes for the current day
            ..._scheduleBoxes.where((box) => box['dayIndex'] == index).map((box) {
              return Positioned(
                top: box['top'],
                height: box['height'],
                width: 100,
                child: Container(
                  color: Colors.green,
                  child: Column(
                    children: [
                      Text(
                        '${box['lecture']} @ ${box['location']}',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    ];
  }

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
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '시간 및 장소 추가',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.add, color: Color(0xff1479FF)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  dayDropDown(),
                  const SizedBox(width: 30),
                  startTimeDropDown(),
                  const SizedBox(width: 8),
                  const SizedBox(width: 10, child: Divider(color: Colors.black, thickness: 1.0)),
                  const SizedBox(width: 12),
                  endTimeDropDown(),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 48,
                decoration: BoxDecoration(color: const Color(0xffCCE0FF), borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  controller: _locationTextController,
                  onEditingComplete: () {
                    setState(() {
                      locationValue = _locationTextController.text;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: '장소',
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 48,
                decoration: BoxDecoration(color: const Color(0xffCCE0FF), borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  controller: _lectureTextController,
                  onEditingComplete: () {
                    setState(() {
                      lectureValue = _lectureTextController.text;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: '수업명',
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    SizedBox(
                    width: 66,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        String id = uuid.v4();
                        await saveScheduleId(id);
                        await saveSchedule(id, {
                          'day': dayDropDownValue,
                          'startTime': startTimeDropDownValue,
                          'endTime': endTimeDropDownValue,
                          'lecture': lectureValue,
                          'location': locationValue,
                        });

                        int dayIndex = week.indexOf(dayDropDownValue.replaceAll('요일', ''));
                        double startTimePosition = calculateTopPosition(startTimeDropDownValue);
                        double boxHeight = calculateBoxHeight(startTimeDropDownValue, endTimeDropDownValue);

                        setState(() {
                          _scheduleBoxes.add({
                            'dayIndex': dayIndex,
                            'top': startTimePosition,
                            'height': boxHeight,
                            'lecture': lectureValue,
                            'location': locationValue,
                          });
                        });

                        Map<String, dynamic> scheduleData = await getSchedule(id);
                        String lectureName = scheduleData['lecture'] ?? '정보 없음';
                        String location = scheduleData['location'] ?? '정보 없음';
                        String day = scheduleData['day'] ?? '정보 없음';
                        String startTime = scheduleData['startTime'] ?? '정보 없음';
                        String endTime = scheduleData['endTime'] ?? '정보 없음';

                        print('강의명: $lectureName');
                        print('강의장소: $location');
                        print('강의시간: $day $startTime-$endTime');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                        backgroundColor: const Color(0xff1479FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('추가하기', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
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
          child: Text('$value요일', style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          dayDropDownValue = value!;
        });
      },
    );
  }

  Widget startTimeDropDown() {
    List<String> time = generateTimeList("9:00", endTimeDropDownValue);

    return DropdownButton(
      value: startTimeDropDownValue,
      items: time.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          startTimeDropDownValue = value!;
        });
      },
    );
  }

  Widget endTimeDropDown() {
    List<String> time = generateTimeList(startTimeDropDownValue, "17:00");

    return DropdownButton(
      value: endTimeDropDownValue,
      items: time.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          endTimeDropDownValue = value!;
        });
      },
    );
  }
}

// Widget buildScheduleBox({
//   required String lecture,
//   required String location,
//   required String time,
//   required VoidCallback onDelete,
// }) {
//   return
// }

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
