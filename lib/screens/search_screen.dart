import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: '검색어를 입력해주세요.',
            border: InputBorder.none,
          ),
          autofocus: true,
        ),
      ),
      body: ListView(
        children: const [
          ListTile(title: Text('최근 검색어')),
          ListTile(title: Text('자전거'), trailing: Icon(Icons.close)),
          ListTile(title: Text('아이폰'), trailing: Icon(Icons.close)),
        ],
      ),
    );
  }
}
