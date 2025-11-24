import 'package:flutter/material.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('동네생활 글쓰기'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              '완료',
              style: TextStyle(color: Color(0xFFFF7E36), fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: '제목을 입력하세요',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '우리 동네 관련된 질문이나 이야기를 해보세요.',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
