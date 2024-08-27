import 'package:flutter/material.dart';

class ChatingPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '택시 팟이 완성되었어요!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '함께하는 사람들과 필요한 대화를 나누어보세요',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            )),
        body: Column(
          children: [
            Expanded(
                child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                ChatBubble(
                  text: '안녕하세요~',
                  isMe: false,
                  nickname: '효정',
                ),
                ChatBubble(
                  text: '다들 어디쯤이세요?? 택시 곧 도착해요!',
                  isMe: false,
                  nickname: '효정',
                ),
                ChatBubble(
                  text: '죄송합니다;;; 빨리 갈게요...',
                  isMe: false,
                  nickname: '효정',
                ),
                ChatBubble(
                  text: '전 이미 와있어요! 노란 옷 입고 있습니다!!',
                  isMe: true,
                  nickname: '나',
                ),
              ],
            )),
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Color(0xFFD3E5FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.near_me_outlined, color: Colors.black, size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String nickname;

  ChatBubble({
    required this.text,
    required this.isMe,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Column(
              children: [
                chatProfile(),
                Text(
                  nickname,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          if (!isMe) SizedBox(width: 8),
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          if (isMe) SizedBox(width: 8),
          if (isMe) chatProfile(),
        ],
      ),
    );
  }
}

Widget chatProfile() {
  return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Center(
          child: Icon(
        Icons.person_outline,
        size: 20,
        color: Colors.black,
      )));
}
