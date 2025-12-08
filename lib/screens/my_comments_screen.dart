import 'package:flutter/material.dart';

/// 내가 작성한 동네생활 댓글 화면
class MyCommentsScreen extends StatelessWidget {
  const MyCommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    // 더미 댓글 데이터 (실제 앱에서는 API에서 가져옴)
    final myComments = <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('동네생활 댓글'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: myComments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 64,
                    color: isDark ? Colors.grey[600] : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '작성한 댓글이 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '동네생활에서 댓글을 작성해보세요!',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: myComments.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDark ? Colors.grey[800] : Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final comment = myComments[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  color: cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['content'] as String? ?? '',
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        comment['time'] as String? ?? '',
                        style: TextStyle(fontSize: 12, color: subTextColor),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
