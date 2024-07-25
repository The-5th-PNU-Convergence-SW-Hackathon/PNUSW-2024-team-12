import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FastmatchPageView extends StatefulWidget {
  const FastmatchPageView({Key? key}) : super(key: key);

  @override
  _FastmatchPageViewState createState() => _FastmatchPageViewState();
}

class _FastmatchPageViewState extends State<FastmatchPageView> {
  bool isQuickMatch = true;

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
                  '매칭',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: isQuickMatch ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isQuickMatch = true;
                      });
                    },
                    child: const Text('빠른 매칭', style: TextStyle(fontSize: 16.0)),
                  ),
                ),
                const Text(' / ', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: isQuickMatch ? Colors.grey : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isQuickMatch = false;
                      });
                    },
                    child: const Text('매칭 예약', style: TextStyle(fontSize: 16.0)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 182, 232, 255),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                "출발지",
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                "서브웨이 부산대점",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                "도착지",
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                "부산대학교",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
                child: ListView.builder(
                    itemCount: isQuickMatch ? 5 : 6,
                    itemBuilder: (context, index) {
                      if (isQuickMatch) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(255, 182, 232, 255),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text(
                                          "출발지",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text(
                                          "서브웨이 부산대점",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.rectangle,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text(
                                          "출발지",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text(
                                          "서브웨이 부산대점",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Text(
                                  "오늘 12:00 탑승 예정",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(255, 182, 232, 255),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text(
                                          "출발지",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text(
                                          "서브웨이 부산대점",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.rectangle,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text(
                                          "출발지",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text(
                                          "서브웨이 부산대점",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Text(
                                  "오늘 12:00 탑승 예정",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
