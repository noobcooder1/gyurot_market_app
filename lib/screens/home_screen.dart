import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Row(
            children: const [Text('역삼동'), Icon(Icons.keyboard_arrow_down)],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        color: const Color(0xFFFF7E36),
        child: ListView.builder(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return ProductItem(product: productList[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFFF7E36),
        child: const Icon(Icons.add),
      ),
    );
  }
}
