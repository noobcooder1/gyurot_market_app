import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: const [
          ListTile(title: Text('공지사항')),
          ListTile(title: Text('국가 설정')),
          ListTile(title: Text('언어 설정')),
          ListTile(title: Text('로그아웃')),
        ],
      ),
    );
  }
}
