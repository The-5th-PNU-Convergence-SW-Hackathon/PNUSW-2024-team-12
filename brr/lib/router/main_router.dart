import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/view/main_page/main_page_view.dart';
import 'package:brr/view/match_page/match_fast_view.dart';
import 'package:brr/layout/main_layout.dart';
import 'package:brr/view/mypage_page/mypage_page_view.dart';
import 'package:brr/view/schedule_page/schedule_page_view.dart';

class MainRouter {
  static final List<GetPage> routes = [
    GetPage(
      name: '/',
      page: () => const MainLayout(
        child: MainPageView(),
      ),
    ),
    GetPage(
      name: '/fastmatch',
      page: () => const MainLayout(
        child: FastmatchPageView(),
      ),
    ),
    GetPage(
      name: '/mypage',
      page: () => const MainLayout(
        child: MypagePageView(),
      ),
    ),
    GetPage(
      name: '/schedule',
      page: () => const MainLayout(
        child: SchedulePageView(),
      ),
    )
  ];
}
