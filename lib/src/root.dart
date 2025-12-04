import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyurot_market/src/common/bottom_nav_controller.dart';

import 'package:gyurot_market/screens/home_screen.dart';
import 'package:gyurot_market/screens/neighborhood_screen.dart';
import 'package:gyurot_market/screens/nearby_screen.dart';
import 'package:gyurot_market/screens/chat_screen.dart';
import 'package:gyurot_market/screens/profile_screen.dart';

class Root extends GetView<BottomNavController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Colors.white;
    final Color inactiveColor = Colors.white.withOpacity(0.6);

    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: const [
          HomeScreen(),
          NeighborhoodScreen(),
          NearbyScreen(),
          ChatScreen(),
          ProfileScreen(),
        ],
      ),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.menuIndex.value,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff212123),
          selectedItemColor: activeColor,
          unselectedItemColor: inactiveColor,
          selectedFontSize: 11.0,
          unselectedFontSize: 11.0,
          onTap: controller.changeBottomNav,
          items: [
            BottomNavigationBarItem(
              label: '홈',
              icon: _buildNavIcon(Icons.home_outlined, inactiveColor),
              activeIcon: _buildNavIcon(Icons.home, activeColor),
            ),
            BottomNavigationBarItem(
              label: '동네생활',
              icon: _buildNavIcon(Icons.article_outlined, inactiveColor),
              activeIcon: _buildNavIcon(Icons.article, activeColor),
            ),
            BottomNavigationBarItem(
              label: '내 근처',
              icon: _buildNavIcon(Icons.location_on_outlined, inactiveColor),
              activeIcon: _buildNavIcon(Icons.location_on, activeColor),
            ),
            BottomNavigationBarItem(
              label: '채팅',
              icon: _buildNavIcon(Icons.chat_bubble_outline, inactiveColor),
              activeIcon: _buildNavIcon(Icons.chat_bubble, activeColor),
            ),
            BottomNavigationBarItem(
              label: '나의 밤톨',
              icon: _buildNavIcon(Icons.person_outline, inactiveColor),
              activeIcon: _buildNavIcon(Icons.person, activeColor),
            ),
          ],
        ),
      ),
    );
  }

  /// 내비게이션 아이콘을 위젯으로 빌드하는 헬퍼 메서드
  Widget _buildNavIcon(IconData iconData, Color color) {
    return Icon(
      iconData,
      size: 26,
      color: color,
      shadows: const [
        Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
      ],
    );
  }
}
