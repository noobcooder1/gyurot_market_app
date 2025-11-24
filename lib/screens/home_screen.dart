import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';
import 'search_screen.dart';
import 'category_screen.dart';
import 'notification_screen.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('역삼동'),
                        onTap: () {},
                        trailing: const Icon(
                          Icons.check,
                          color: Color(0xFFFF7E36),
                        ),
                      ),
                      ListTile(title: const Text('내 동네 설정'), onTap: () {}),
                    ],
                  ),
                );
              },
            );
          },
          child: Row(
            children: const [Text('역삼동'), Icon(Icons.keyboard_arrow_down)],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryScreen()),
              );
            },
            icon: const Icon(Icons.menu),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        backgroundColor: const Color(0xFFFF7E36),
        child: const Icon(Icons.add),
      ),
    );
  }
}
