import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../screens/home_screen.dart';

class Root extends GetView {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          const HomeScreen(), // 우선 홈 화면을 보여줍니다. 나중에 IndexedStack 등으로 탭 전환 구현 필요
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed, // 타입 설정 수정
        backgroundColor: const Color(0xff212123),
        selectedItemColor: const Color(0xffffffff),
        unselectedItemColor: const Color(0xffffffff).withOpacity(0.6),
        selectedFontSize: 11.0,
        unselectedFontSize: 11.0,
        onTap: (int pageIndex) {
          // 탭 전환 로직은 나중에 컨트롤러와 연결
        },
        items: [
          BottomNavigationBarItem(
            label: '홈',
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/home-off.svg'),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/home-on.svg'),
            ),
          ),
          BottomNavigationBarItem(
            label: '동네 생활',
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/arround-life-off.svg'),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/arround-life-on.svg'),
            ),
          ),
          BottomNavigationBarItem(
            label: '내 근처',
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/arround-near-off.svg'),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/arround-near-on.svg'),
            ),
          ),
          BottomNavigationBarItem(
            label: '채팅',
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/arround-chat-off.svg'),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/arround-chat-on.svg'),
            ),
          ),
          BottomNavigationBarItem(
            label: '나의 밤톨',
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/arround-my-off.svg'),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svg/icons/arround-my-on.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
