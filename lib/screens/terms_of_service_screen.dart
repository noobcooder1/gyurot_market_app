import 'package:flutter/material.dart';

/// 이용약관 화면
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
        title: const Text('이용약관'),
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
              '이용약관',
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
              '제1조 (목적)',
              '''이 약관은 규롯마켓(이하 "회사")이 제공하는 중고거래 플랫폼 서비스(이하 "서비스")의 이용조건 및 절차, 회사와 회원 간의 권리, 의무 및 책임사항 등을 규정함을 목적으로 합니다.''',
              textColor,
              subTextColor!,
            ),
            _buildSection(
              '제2조 (정의)',
              '''1. "서비스"란 회사가 제공하는 중고물품 거래 중개 플랫폼 및 관련 제반 서비스를 의미합니다.

2. "회원"이란 본 약관에 동의하고 회원가입을 한 자로서 서비스를 이용하는 자를 말합니다.

3. "게시물"이란 회원이 서비스를 이용하면서 게시한 글, 사진, 동영상, 댓글 등을 의미합니다.''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제3조 (약관의 효력 및 변경)',
              '''1. 본 약관은 서비스를 이용하고자 하는 모든 회원에게 적용됩니다.

2. 회사는 약관을 변경할 수 있으며, 변경된 약관은 서비스 내 공지사항을 통해 공지합니다.

3. 회원이 변경된 약관에 동의하지 않는 경우 회원 탈퇴를 요청할 수 있습니다.''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제4조 (회원가입)',
              '''1. 이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 약관에 동의함으로써 회원가입을 신청합니다.

2. 회사는 다음 각 호에 해당하는 신청에 대하여는 승낙을 거부할 수 있습니다.
- 타인의 명의를 이용한 경우
- 허위 정보를 기재한 경우
- 기타 회원으로 등록하는 것이 서비스 운영에 현저히 지장이 있다고 판단되는 경우''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제5조 (서비스의 제공)',
              '''회사는 다음과 같은 서비스를 제공합니다.

1. 중고물품 판매 및 구매 정보 제공 서비스
2. 판매자와 구매자 간의 채팅 서비스
3. 위치기반 동네 설정 서비스
4. 동네생활 커뮤니티 서비스
5. 기타 회사가 정하는 서비스''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제6조 (회원의 의무)',
              '''1. 회원은 다음 행위를 하여서는 안 됩니다.
- 허위 정보의 등록
- 타인의 정보 도용
- 서비스에 게시된 정보의 무단 변경
- 회사가 금지한 정보의 송신 또는 게시
- 회사 및 기타 제3자의 저작권 등 지적재산권에 대한 침해
- 회사 및 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위
- 외설 또는 폭력적인 메시지, 화상, 음성 기타 공서양속에 반하는 정보의 게시

2. 회원은 관계법령, 본 약관, 서비스 이용안내 등을 준수하여야 합니다.''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제7조 (게시물의 관리)',
              '''1. 회원의 게시물이 다음 각 호에 해당하는 경우 회사는 해당 게시물을 삭제하거나 게시를 거부할 수 있습니다.
- 다른 회원 또는 제3자를 비방하거나 명예를 훼손하는 내용
- 음란물 또는 불법 정보를 담고 있는 경우
- 회사의 서비스 운영을 방해하는 경우

2. 회원은 언제든지 자신이 게시한 게시물을 삭제할 수 있습니다.''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제8조 (서비스 이용제한)',
              '''회사는 회원이 본 약관의 의무를 위반하거나 서비스의 정상적인 운영을 방해한 경우 서비스 이용을 제한하거나 회원자격을 박탈할 수 있습니다.''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제9조 (면책조항)',
              '''1. 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 책임이 면제됩니다.

2. 회사는 회원 간 또는 회원과 제3자 간에 서비스를 매개로 하여 발생한 분쟁에 대해서는 개입할 의무가 없으며, 이로 인한 손해를 배상할 책임을 지지 않습니다.

3. 회원이 서비스를 이용하여 기대하는 수익을 얻지 못한 것에 대하여 회사는 책임을 지지 않습니다.''',
              textColor,
              subTextColor,
            ),
            _buildSection(
              '제10조 (분쟁해결)',
              '''1. 회사와 회원 간에 발생한 분쟁은 상호 협의하여 해결합니다.

2. 협의가 이루어지지 않을 경우 관할 법원은 회사의 소재지를 관할하는 법원으로 합니다.''',
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
                    '문의처',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('회사명: 규롯마켓', style: TextStyle(color: subTextColor)),
                  Text(
                    '이메일: support@gyurot.com',
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
