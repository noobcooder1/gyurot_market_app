import 'package:flutter/material.dart';

class StoreCategoryScreen extends StatelessWidget {
  final String categoryName;

  const StoreCategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Center(child: Text('$categoryName 카테고리의 가게 목록입니다.')),
    );
  }
}
