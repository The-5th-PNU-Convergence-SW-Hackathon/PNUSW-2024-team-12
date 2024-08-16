import 'package:flutter/material.dart';
import 'package:brr/view/loading_circle/loading_circle.dart';
import 'package:get/get.dart';

class matchLoadingPageView extends StatelessWidget {
  const matchLoadingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BouncingDots(),
                const SizedBox(height: 50),
                const Text(
                  '매칭을 시도하는 중이에요',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '현재 3/4 모집중',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '현재 인원으로 출발하기를 원하시면\n아래의 출발해요 버튼을 눌러주세요',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_taxi_outlined, color: Colors.blue, size: 50),
                    SizedBox(width: 8),
                    Icon(Icons.people_outline_outlined, color: Colors.blue, size: 50),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('출발해요!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('매칭 취소', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 50.0,
            left: 30.0,
            child: SizedBox(
              width: 35.0,
              height: 35.0,
              child: FloatingActionButton(
                onPressed: () {
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
            ),
          )
        ],
      ),
    );
  }
}
