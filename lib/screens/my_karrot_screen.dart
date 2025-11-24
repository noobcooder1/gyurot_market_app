import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'history_screen.dart';

class MyKarrotScreen extends StatelessWidget {
  const MyKarrotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfileProvider>().userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 당근'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: userProfile.profileImage != null
                        ? FileImage(File(userProfile.profileImage!))
                        : null,
                    child: userProfile.profileImage == null
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfile.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(userProfile.id),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: const Text('프로필 보기'),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            // Menu Items
            _buildMenuItem(context, Icons.receipt_long, '판매내역'),
            _buildMenuItem(context, Icons.shopping_bag_outlined, '구매내역'),
            _buildMenuItem(context, Icons.favorite_border, '관심목록'),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            _buildMenuItem(context, Icons.location_on_outlined, '동네 인증하기'),
            _buildMenuItem(context, Icons.settings_outlined, '키워드 알림'),
            _buildMenuItem(context, Icons.tune, '모아보기 설정'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen(title: title)),
        );
      },
    );
  }
}
