import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'schedule.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE schedules (
            id TEXT PRIMARY KEY,
            jsonData TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE schedule_ids (
            id TEXT PRIMARY KEY
          )
        ''');
      },
    );
  }
}

List<String> week = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];

int getCurrentDayIndex() {
  return DateTime.now().weekday % 7;
}

String getCurrentTime() {
  final now = DateTime.now();
  return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
}

const Uuid uuid = Uuid();
final DatabaseHelper dbHelper = DatabaseHelper();

Future<void> saveSchedule(String id, Map<String, dynamic> jsonData) async {
  final db = await dbHelper.database;
  String jsonString = jsonEncode(jsonData);
  await db.insert(
    'schedules',
    {'id': id, 'jsonData': jsonString},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Map<String, dynamic>> getSchedule(String id) async {
  final db = await dbHelper.database;
  List<Map<String, dynamic>> results = await db.query(
    'schedules',
    where: 'id = ?',
    whereArgs: [id],
  );
  if (results.isNotEmpty) {
    String jsonString = results.first['jsonData'] as String;
    return jsonDecode(jsonString);
  }
  return {};
}

Future<void> delSchedule(String id) async {
  final db = await dbHelper.database;
  await db.delete(
    'schedules',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<List<String>> getAllScheduleIds() async {
  final db = await dbHelper.database;
  List<Map<String, dynamic>> results = await db.query('schedule_ids');
  return results.map((row) => row['id'] as String).toList();
}

Future<void> saveScheduleId(String id) async {
  final db = await dbHelper.database;
  await db.insert(
    'schedule_ids',
    {'id': id},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> delScheduleId(String id) async {
  final db = await dbHelper.database;
  await db.delete(
    'schedule_ids',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<Map<String, dynamic>> getNextSchedule() async {
  final currentDayIndex = getCurrentDayIndex();
  final currentTimeString = getCurrentTime();
  final currentTime = DateFormat('HH:mm').parse(currentTimeString);
  final scheduleIds = await getAllScheduleIds();
  List<Map<String, dynamic>> schedules = [];

  for (String id in scheduleIds) {
    final schedule = await getSchedule(id);
    schedules.add(schedule);
    }

  List<Map<String, dynamic>> upcomingSchedules = [];

  for (int i = 0; i <= 1; i++) {
    final dayIndex = (currentDayIndex + i) % 7 == 0 ? 6 : (currentDayIndex + i) % 7 - 1;
    final dayName = week[dayIndex];

    final daySchedules = schedules.where((schedule) => schedule['day'] == dayName).toList();

    for (var schedule in daySchedules) {
      final startTimeString = schedule['startTime'] ?? '00:00';
      final endTimeString = schedule['endTime'] ?? '00:00';
      final startTime = DateFormat('HH:mm').parse(startTimeString);

      if(i==0) {
        if (startTime.isAfter(currentTime)) {
          upcomingSchedules.add({
            ...schedule,
            'startTime': startTimeString,
            'endTime': endTimeString,
            'day': schedule['day'] ?? '',
            'location': schedule['location'] ?? '',
          });
        }
      }
      else {
        upcomingSchedules.add({
          ...schedule,
          'startTime': startTimeString,
          'endTime': endTimeString,
          'day': schedule['day'] ?? '',
          'location': schedule['location'] ?? '',
        });
      }
    }

    if (upcomingSchedules.isNotEmpty) {
      upcomingSchedules.sort((a, b) {
        final startTimeA = DateFormat('HH:mm').parse(a['startTime'] as String);
        final startTimeB = DateFormat('HH:mm').parse(b['startTime'] as String);
        return startTimeA.compareTo(startTimeB);
      });
      return upcomingSchedules.first;
    }
  }

  return {
    'lecture': '다음 수업이 없습니다.',
    'startTime': '',
    'endTime': '',
    'day': '',
    'location': ''
  };
}


String getTimeDifferenceString(String startTimeString) {
  try {
    final now = DateTime.now();
    final currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    final startTime = DateFormat('HH:mm').parse(startTimeString, false);
    final startDateTime = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);

    final targetTime = startDateTime.isAfter(currentTime)
        ? startDateTime
        : startDateTime.add(const Duration(days: 1)); // 하루 더함

    final difference = targetTime.difference(currentTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return '$hours 시간 $minutes 분 후';
  } catch (e) {
    return '오류 발생: $e';
  }
}
