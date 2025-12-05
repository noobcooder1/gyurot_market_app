import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final faqs = [
      {
        'question': '상품을 어떻게 등록하나요?',
        'answer': '홈 화면의 "글쓰기" 버튼을 눌러 상품 정보를 입력하고 등록하시면 됩니다.',
      },
      {
        'question': '거래는 어떻게 진행하나요?',
        'answer': '관심있는 상품의 채팅하기 버튼을 눌러 판매자와 시간, 장소를 정하고 직거래합니다.',
      },
      {
        'question': '가격 협상이 가능한가요?',
        'answer': '채팅을 통해 판매자와 협의하시면 됩니다. 가격 제안 가능한 상품은 표시됩니다.',
      },
      {
        'question': '사기 피해를 당했어요',
        'answer': '고객센터로 연락주시면 도움을 드리겠습니다. 거래 전 매너온도를 확인해주세요.',
      },
      {
        'question': '내 동네를 어떻게 설정하나요?',
        'answer': '프로필 > 설정 > 내 동네 설정에서 변경할 수 있습니다.',
      },
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('자주 묻는 질문'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return ExpansionTile(
            title: Text(
              faq['question']!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            iconColor: const Color(0xFFFF6F0F),
            collapsedIconColor: isDark ? Colors.grey[500] : Colors.grey[600],
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  faq['answer']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
