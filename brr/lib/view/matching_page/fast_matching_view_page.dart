import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:brr/controller/add_match_list_controller.dart';

class MatchingPageView extends StatelessWidget {
  const MatchingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.put(LocationController());

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.blueGrey,
            child: const Center(
              child: Image(
                image: AssetImage('assets/images/map.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.57,
            minChildSize: 0.12,
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              return Container(
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                              ),
                              const SizedBox(height: 15),
                              const Text('약 13분 소요',
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                              const SizedBox(height: 15),
                              const Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                '매칭 할 인원을 선택하세요',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _matchpeopleButton('2인 이상', '5500원 이상', 2),
                                  _matchpeopleButton('3인 이상', '3700원 이상', 3),
                                  _matchpeopleButton('4인 ', '2850원 이상', 4),
                                  _matchpeopleButton('상관\n없음', '', 1),
                                ],
                              ),
                              const SizedBox(height: 15),
                              const Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              const SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  '  결제 수단',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 180,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "부르릉 캐시",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.add, size: 15, color: Colors.blue),
                                              SizedBox(width: 3),
                                              Text(
                                                '충전하기',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        BRRcashIcon(),
                                        SizedBox(width: 10),
                                        Text(
                                          "15,800 캐시",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    final AddMatchListController addMatchListController = Get.put(AddMatchListController());

                                    if (addMatchListController.selectedMinMember.value == 0 && locationController.startLocation.value == '' && locationController.endLocation.value == '') {
                                      Get.snackbar('Error', '매칭 조건(출발지/도착지/인원)을 모두 채워주세요.');
                                    } else if (locationController.startLocation.value == '' || locationController.endLocation.value == '') {
                                      Get.snackbar('Error', '출발지와 도착지를 채워주세요.');
                                    } else if (addMatchListController.selectedMinMember.value == 0) {
                                      Get.snackbar('Error', '매칭 할 인원을 선택해주세요.');
                                    } else {
                                      addMatchListController.sendMatchData(addMatchListController.selectedMinMember.value);
                                      Get.toNamed('/matchloading');
                                    }
                                  },
                                  child: const Text(
                                    '매칭 시작하기',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          )),
                    ],
                  ));
            }),
        Positioned(
          top: 50.0,
          left: 30.0,
          child: Row(
            children: [
              goBackButton(),
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/writelocation');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.1),
                ),
                child: SizedBox(
                  width: 270.0,
                  height: 70,
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          locationRow(circleContainer, '출발지', locationController.startLocation.value.isEmpty ? '' : locationController.startLocation.value),
                          const SizedBox(height: 5.0),
                          locationRow(rectangularContainer, '도착지', locationController.endLocation.value.isEmpty ? '' : locationController.endLocation.value),
                        ],
                      )),
                ),
              )
            ],
          ),
        )
      ],
    )));
  }

  Widget _matchpeopleButton(String text, String subtext, int minMember) {
    final AddMatchListController addMatchListController = Get.put(AddMatchListController());

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(() => SizedBox(
            width: 80,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: addMatchListController.selectedMinMember.value == minMember ? Colors.blue : Colors.white,
                backgroundColor: addMatchListController.selectedMinMember.value == minMember ? Colors.white : Colors.blue,
                side: addMatchListController.selectedMinMember.value == minMember ? const BorderSide(color: Colors.blue, width: 2) : BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                if (addMatchListController.selectedMinMember.value == minMember) {
                  addMatchListController.selectedMinMember.value = 0;
                } else {
                  addMatchListController.selectedMinMember.value = minMember;
                }
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: addMatchListController.selectedMinMember.value == minMember ? Colors.blue : Colors.white,
                      ),
                    ),
                    subtext == ''
                        ? Container()
                        : Text(
                            subtext,
                            style: TextStyle(
                              fontSize: 12,
                              color: addMatchListController.selectedMinMember.value == minMember ? Colors.blue : Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget locationRow(Widget icon, String title, String subtitle) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 10.0),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 5.0),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget goBackButton() {
    return SizedBox(
      width: 35.0,
      height: 35.0,
      child: FloatingActionButton(
        onPressed: () {
          final AddMatchListController addMatchListController = Get.find<AddMatchListController>();
          final LocationController locationController = Get.find<LocationController>();

          addMatchListController.selectedMinMember.value = 0;
          locationController.startLocation.value = '';
          locationController.endLocation.value = '';
          Get.back();
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 4.0,
        child: const Icon(
          Icons.arrow_back,
          size: 20.0,
        ),
      ),
    );
  }
}
