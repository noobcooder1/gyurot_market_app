import 'package:flutter/material.dart';

/// 개인정보 처리방침 화면
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        title: const Text('개인정보 처리방침'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '개인정보 처리방침',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '시행일: 2024년 12월 1일',
              style: TextStyle(fontSize: 14, color: subTextColor),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제1조 (개인정보의 수집 및 이용 목적)',
              '''규롯마켓(이하 "회사")은 다음의 목적을 위하여 개인정보를 처리합니다.

1. 회원 가입 및 관리
- 회원제 서비스 제공에 따른 본인 식별·인증
- 회원자격 유지·관리
- 서비스 부정이용 방지

2. 서비스 제공
- 물품 거래 서비스 제공
- 채팅 및 알림 서비스 제공
- 위치 기반 서비스 제공

3. 마케팅 및 광고에의 활용
- 이벤트 및 광고성 정보 제공''',
              textColor,
              subTextColor!,
            ),
            _buildSection(
              '제2조 (수집하는 개인정보의 항목)',
              '''회사는 다음의 개인정보 항목을 수집합니다.

1. 필수항목
- 이메일 주소, 비밀번호, 닉네임
- 휴대폰 번호 (본인인증 시)

2. 선택항목
- 프로필 사진
- 위치 정보

3. 자동 수집항목
- IP 주소, 쿠키, 접속 로그
- 서비스 이용 기록''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제3조 (개인정보의 보유 및 이용기간)',
              '''회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.

1. 회원 정보: 회원 탈퇴 시까지
2. 거래 기록: 전자상거래법에 따라 5년
3. 소비자 불만 또는 분쟁 처리에 관한 기록: 3년''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제4조 (개인정보의 제3자 제공)',
              '''회사는 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.

1. 이용자가 사전에 동의한 경우
2. 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제5조 (개인정보의 파기)',
              '''회사는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.

파기절차:
이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져 내부 방침 및 기타 관련 법령에 따라 일정 기간 저장된 후 혹은 즉시 파기됩니다.''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제6조 (이용자의 권리)',
              '''이용자는 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.

1. 개인정보 열람 요구
2. 오류 등이 있을 경우 정정 요구
3. 삭제 요구
4. 처리정지 요구''',
              textColor,
              subTextColor,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '개인정보 보호책임자',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('이름: 홍길동', style: TextStyle(color: subTextColor)),
                  Text(
                    '이메일: privacy@gyurot.com',
                    style: TextStyle(color: subTextColor),
                  ),
                  Text('전화: 1588-0000', style: TextStyle(color: subTextColor)),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    String content,
    Color textColor,
    Color subTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 14, height: 1.6, color: subTextColor),
          ),
        ],
      ),
    );
  }
}
