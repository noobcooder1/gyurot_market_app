import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          '채팅',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: _buildChatList(context, isDark),
    );
  }

  Widget _buildChatList(BuildContext context, bool isDark) {
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[300];
    final chats = [
      {
        'name': '김철수',
        'lastMessage': '네, 내일 거래 가능합니다!',
        'time': '오후 3:24',
        'unread': 2,
        'product': '아이폰 13 프로',
      },
      {
        'name': '이영희',
        'lastMessage': '감사합니다~ 좋은 하루 되세요!',
        'time': '오전 11:30',
        'unread': 0,
        'product': '닌텐도 스위치',
      },
      {
        'name': '박민수',
        'lastMessage': '가격 조금 낮춰주실 수 있나요?',
        'time': '어제',
        'unread': 0,
        'product': '자전거',
      },
      {
        'name': '최수진',
        'lastMessage': '어디서 만날까요?',
        'time': '어제',
        'unread': 1,
        'product': '에어팟 프로',
      },
    ];

    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              '채팅 내역이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, indent: 76, color: dividerColor),
      itemBuilder: (context, index) =>
          _buildChatItem(context, chats[index], isDark),
    );
  }

  Widget _buildChatItem(
    BuildContext context,
    Map<String, dynamic> chat,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final avatarBgColor = isDark ? Colors.grey[700] : Colors.grey[200];
    final imageBgColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatDetailScreen(chat: chat)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: avatarBgColor,
              child: Text(
                chat['name'].substring(0, 1),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        chat['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        chat['time'],
                        style: TextStyle(fontSize: 12, color: subTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat['lastMessage'],
                    style: TextStyle(fontSize: 14, color: subTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: imageBgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.image, color: subTextColor),
                ),
                if (chat['unread'] > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6F0F),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${chat['unread']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
