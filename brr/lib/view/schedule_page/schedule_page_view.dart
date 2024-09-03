import 'package:flutter/material.dart';
import 'package:brr/util.dart';

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
      if (i == startHour && j < startMin) {
        continue;
      }
      if (j == 0) {
        timeList.add('$i:00');
        continue;
      }
      timeList.add('$i:$j');
    }
  }

  if (endHour != 17) {
    for (int i = 0; i < endMin; i += 10) {
      if (i == 0) {
        timeList.add('$endHour:00');
        continue;
      }
      timeList.add('$endHour:$i');
    }
  } else {
    timeList.add('17:00');
  }
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
  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    // 모든 스케줄 ID 가져오기
    List<String> scheduleIds = await getAllScheduleIds();

    for (String id in scheduleIds) {
      // 각 스케줄의 데이터를 가져와서 UI에 반영
      Map<String, dynamic> scheduleData = await getSchedule(id);

      if (scheduleData.isNotEmpty) {
        int dayIndex = week.indexOf(scheduleData['day'].replaceAll('요일', ''));
        double startTimePosition = calculateTopPosition(scheduleData['startTime']);
        double boxHeight = calculateBoxHeight(scheduleData['startTime'], scheduleData['endTime']);

        setState(() {
          _scheduleBoxes.add({
            'id': id,
            'dayIndex': dayIndex,
            'top': startTimePosition,
            'height': boxHeight,
            'lecture': scheduleData['lecture'],
            'location': scheduleData['location'],
          });
        });
      }
    }
  }

  final TextEditingController _lectureTextController = TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();

  final List<Map<String, dynamic>> _scheduleBoxes = [];

  List<Widget> buildDayColumn(BuildContext context, int index) {
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
            ..._scheduleBoxes.where((box) => box['dayIndex'] == index).map((box) {
              return Positioned(
                top: box['top'],
                height: box['height'],
                width: 100,
                child: GestureDetector(
                  onTap: () {
                    _showDeleteConfirmationDialog(context, box['id']);
                  },
                  child: Container(
                    color: Colors.blue,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(1),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 45,
                              child: Text(
                                '${box['lecture']}',
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                            SizedBox(
                              width: 45,
                              child: Text(
                                '${box['location']}',
                                style: const TextStyle(color: Colors.white, fontSize: 8),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        ...buildDayColumn(context, 0),
                        ...buildDayColumn(context, 1),
                        ...buildDayColumn(context, 2),
                        ...buildDayColumn(context, 3),
                        ...buildDayColumn(context, 4),
                        ...buildDayColumn(context, 5),
                        ...buildDayColumn(context, 6),
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
                  onChanged: (text) {
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
                  onChanged: (text) {
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
                        String id = uuid.v4(); // 새로운 고유 ID 생성

                        // 스케줄을 데이터베이스에 저장
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
                            'id': id, // 고유 ID 추가
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

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 사용자가 바깥을 터치하면 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('시간표 삭제'),
          content: const Text('시간표를 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('아니요'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('예'),
              onPressed: () async {
                Navigator.of(context).pop();
                await delSchedule(id); // 데이터베이스에서 삭제
                setState(() {
                  _scheduleBoxes.removeWhere((box) => box['id'] == id); // 화면에서 삭제
                });
              },
            ),
          ],
        );
      },
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
              child: Center(
                  child: Text(
                '${index ~/ 2 + 9}',
                style: const TextStyle(fontSize: 10),
              )),
            );
          },
        ),
      ],
    ),
  );
}
