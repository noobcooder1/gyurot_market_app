import 'package:flutter/material.dart';

/// 받은 매너 평가 화면
class MannerReviewScreen extends StatelessWidget {
  const MannerReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    // 더미 매너 평가 데이터
    final mannerItems = <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('받은 매너 평가'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 매너온도 카드
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('😊', style: TextStyle(fontSize: 48)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '매너온도',
                          style: TextStyle(fontSize: 14, color: subTextColor),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '36.5°C',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6F0F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 온도 막대
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.365,
                    minHeight: 8,
                    backgroundColor: isDark
                        ? Colors.grey[700]
                        : Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF6F0F),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0°C',
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                    Text(
                      '100°C',
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 평가 목록
          Expanded(
            child: mannerItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_border,
                          size: 64,
                          color: isDark ? Colors.grey[600] : Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '받은 매너 평가가 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey[400] : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '거래를 완료하면 매너 평가를 받을 수 있어요!',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: mannerItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = mannerItems[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['text'] as String? ?? '',
                          style: TextStyle(color: textColor),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
