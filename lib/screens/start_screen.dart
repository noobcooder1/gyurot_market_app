import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_font.dart';
import '../widgets/btn.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212123),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 99,
              height: 116,
              child: Image.asset('assets/images/logo_simbol.png'),
            ),
            const SizedBox(height: 40),
            const AppFont('당신 근처의 규롯마켓', fontWeight: FontWeight.bold, size: 20),
            const SizedBox(height: 15),
            AppFont(
              '중고 거래부터 동네 정보까지, \n지금 내 동네를 선택하고 시작해보세요!',
              align: TextAlign.center,
              size: 18,
              color: Colors.white.withOpacity(0.6),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 25,
          right: 25,
          bottom: 25 + MediaQuery.of(context).padding.bottom,
        ),
        child: Btn(
          onTap: () {
            Get.toNamed('/login');
          },
          child: const AppFont(
            '시작하기',
            align: TextAlign.center,
            size: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
