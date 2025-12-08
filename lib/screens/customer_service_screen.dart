import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

/// 고객센터 화면
class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@gyurot.com',
      queryParameters: {'subject': '[규롯마켓 문의]'},
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar('오류', '이메일 앱을 열 수 없습니다');
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '1588-0000');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar('오류', '전화 앱을 열 수 없습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('고객센터'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(24),
              color: cardColor,
              width: double.infinity,
              child: Column(
                children: [
                  Icon(
                    Icons.headset_mic,
                    size: 64,
                    color: const Color(0xFFFF6F0F),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '무엇을 도와드릴까요?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '궁금한 점이나 불편한 점이 있으시면\n언제든 문의해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: subTextColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 연락 방법
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '문의 방법',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 이메일
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F0F).withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.email_outlined,
                    color: Color(0xFFFF6F0F),
                  ),
                ),
                title: Text('이메일 문의', style: TextStyle(color: textColor)),
                subtitle: Text(
                  'support@gyurot.com',
                  style: TextStyle(color: subTextColor),
                ),
                trailing: Icon(Icons.chevron_right, color: subTextColor),
                onTap: _launchEmail,
              ),
            ),
            const SizedBox(height: 12),
            // 전화
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F0F).withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.phone_outlined,
                    color: Color(0xFFFF6F0F),
                  ),
                ),
                title: Text('전화 문의', style: TextStyle(color: textColor)),
                subtitle: Text(
                  '1588-0000 (평일 09:00~18:00)',
                  style: TextStyle(color: subTextColor),
                ),
                trailing: Icon(Icons.chevron_right, color: subTextColor),
                onTap: _launchPhone,
              ),
            ),
            const SizedBox(height: 24),
            // 운영시간
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '운영 시간',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeRow(
                    '평일',
                    '09:00 ~ 18:00',
                    textColor,
                    subTextColor!,
                  ),
                  const SizedBox(height: 8),
                  _buildTimeRow(
                    '점심시간',
                    '12:00 ~ 13:00',
                    textColor,
                    subTextColor,
                  ),
                  const SizedBox(height: 8),
                  _buildTimeRow('토/일/공휴일', '휴무', textColor, subTextColor),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(
    String label,
    String time,
    Color textColor,
    Color subTextColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: subTextColor)),
        Text(
          time,
          style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
        ),
      ],
    );
  }
}
