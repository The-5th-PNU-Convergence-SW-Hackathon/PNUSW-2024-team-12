import 'package:flutter/material.dart';

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
        body: Padding(
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
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    TableRow(children: [
                      for (var day in ['월', '화', '수', '목', '금', '토', '일'])
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(day, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ),
                        ),
                    ]),
                    for (var i = 0; i < 10; i++)
                      TableRow(
                        children: [
                          for (var j in ['시간 1', '시간 2', '시간 3', '시간 4', '시간 5', '시간 6', '시간 7'])
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 30,
                              ),
                            ),
                        ],
                      ),
                  ],
                )
              ],
            )));
  }
}
