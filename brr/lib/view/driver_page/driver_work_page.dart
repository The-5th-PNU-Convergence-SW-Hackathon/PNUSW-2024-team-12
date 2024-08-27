import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/view/loading_circle/loading_circle.dart';
import 'package:brr/controller/quickmatch_list_controller.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:brr/constants/url.dart';

class WebSocketManager extends GetxController {
  final int taxiRoomId;
  late WebSocketChannel channel;

  RxList<dynamic> quickMatches = <dynamic>[].obs;

  WebSocketManager(this.taxiRoomId) {
    connect();
  }

  void connect() {
    final url = 'ws://${Urls.wsUrl}taxi/$taxiRoomId/ws';
    channel = WebSocketChannel.connect(Uri.parse(url));

    channel.stream.listen((message) {
      final data = jsonDecode(message) as List<dynamic>;
      quickMatches.value = data;
      print(quickMatches.value);
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket closed');
    });
  }

  void disconnect() {
    channel.sink.close();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}

class DriverWorkPageView extends StatefulWidget {
  DriverWorkPageView({super.key});

  @override
  State<DriverWorkPageView> createState() => _DriverWorkPageView();
}

class _DriverWorkPageView extends State<DriverWorkPageView> {
  final QuickMatchController quickMatchController = Get.put(QuickMatchController());
  late WebSocketManager webSocketManager;

  @override
  void initState() {
    super.initState();
    webSocketManager = WebSocketManager(0); // Assuming room ID is 0
  }

  @override
  void dispose() {
    webSocketManager.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            titleSpacing: 25.0,
            title: Row(
              children: [brrLogo(), const SizedBox(width: 22), const Text('기사앱', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))],
            )),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    BouncingDots(),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '콜 대기 중',
                          style: const TextStyle(fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text("부산광역시 금정구", style: const TextStyle(fontSize: 15, color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 50),
                    stopButton(),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.57,
              minChildSize: 0.12,
              maxChildSize: 0.7,
              builder: (context, scrollController) {
                return Container(
                    decoration: const BoxDecoration(color: Color(0xFFF3F8FF), borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Obx(() {
                            if (webSocketManager.quickMatches.isEmpty) {
                              return const Center(child: Text("빠른 매칭이 없습니다."));
                            }
                            int itemCount = webSocketManager.quickMatches.length;
                            return ListView.builder(
                              controller: scrollController,
                              itemCount: itemCount,
                              itemBuilder: (context, index) {
                                final quickMatch = webSocketManager.quickMatches[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0),
                                  child: ElevatedButton(
                                    style: buttonStyle(),
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            locationRow(circleContainer, "출발지", quickMatch['depart']),
                                            const SizedBox(height: 5.0),
                                            locationRow(rectangularContainer, "도착지", quickMatch['dest']),
                                          ],
                                        ),
                                        const Spacer(),
                                        boardingInfo(""),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        )
                      ],
                    ));
              },
            )
          ],
        ));
  }

  Widget stopButton() {
    return Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 235, 241, 249),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(3, 5),
            ),
          ],
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.blue,
              elevation: 3,
              shadowColor: const Color.fromARGB(255, 28, 137, 226),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              dispose();
              Get.toNamed('/drivermain');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('콜 멈추기', style: const TextStyle(fontSize: 35, color: Colors.white)),
              ],
            )));
  }
}
