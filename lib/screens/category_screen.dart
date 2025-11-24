import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.tv, 'text': '디지털기기'},
      {'icon': Icons.chair, 'text': '가구/인테리어'},
      {'icon': Icons.child_care, 'text': '유아동'},
      {'icon': Icons.checkroom, 'text': '여성의류'},
      {'icon': Icons.face, 'text': '뷰티/미용'},
      {'icon': Icons.kitchen, 'text': '생활/가전'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('카테고리')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(categories[index]['icon'], size: 40),
              const SizedBox(height: 8),
              Text(categories[index]['text']),
            ],
          );
        },
      ),
    );
  }
}
