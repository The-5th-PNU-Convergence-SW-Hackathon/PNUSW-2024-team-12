import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/view/main_page/main_page_view.dart';
import 'package:brr/layout/main_layout.dart';

class MainRouter {
  static final List<GetPage> routes = [
    GetPage(
      name: '/',
      page: () => const MainLayout(
        child: MainPageView(),
      ),
    ),
  ];
}
