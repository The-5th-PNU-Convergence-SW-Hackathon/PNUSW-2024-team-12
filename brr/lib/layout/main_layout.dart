import 'package:flutter/material.dart';
import 'package:brr/bottom_navigation.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Row(children: [
          Expanded(
              child: SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            child: child,
          ))
        ])),
        const MyBottomNavigationBar(),
      ],
    )));
  }
}
