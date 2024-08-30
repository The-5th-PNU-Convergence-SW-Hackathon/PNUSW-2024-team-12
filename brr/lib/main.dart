import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/router/main_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:developer';
void main() async{
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'lpl7771v5k',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
  await initializeDateFormatting('ko_KR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Brr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Pretendard" //기본 폰트 Pretendard로 설정
      ),
      initialRoute: '/login',
      getPages: MainRouter.routes,
    );
  }
}
