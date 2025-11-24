import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final String title;

  const HistoryScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title 목록이 없습니다.')),
    );
  }
}
