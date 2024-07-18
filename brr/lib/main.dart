import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/router/main_router.dart';

void main() {
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
      ),
      initialRoute: '/',
      getPages: MainRouter.routes,
    );
  }
}
