import 'package:flutter/material.dart';

class MyKarrotScreen extends StatelessWidget {
  const MyKarrotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 당근'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '당근이',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('#123456'),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('프로필 보기'),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            // Menu Items
            _buildMenuItem(Icons.receipt_long, '판매내역'),
            _buildMenuItem(Icons.shopping_bag_outlined, '구매내역'),
            _buildMenuItem(Icons.favorite_border, '관심목록'),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            _buildMenuItem(Icons.location_on_outlined, '동네 인증하기'),
            _buildMenuItem(Icons.settings_outlined, '키워드 알림'),
            _buildMenuItem(Icons.tune, '모아보기 설정'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {},
    );
  }
}
