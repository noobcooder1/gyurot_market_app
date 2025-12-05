import 'package:flutter/material.dart';
import 'neighborhood_post_detail_screen.dart';
import 'neighborhood_write_screen.dart';

class NeighborhoodScreen extends StatelessWidget {
  const NeighborhoodScreen({super.key});

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
          '동네생활',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('검색 기능')));
            },
            icon: Icon(Icons.search, color: iconColor),
            tooltip: '검색',
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('알림 기능')));
            },
            icon: Icon(Icons.notifications_outlined, color: iconColor),
            tooltip: '알림',
          ),
        ],
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          _buildCategorySection(context, isDark, cardColor),
          Divider(
            height: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
          _buildPostList(context, isDark, cardColor),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NeighborhoodWriteScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFFF6F0F),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          '글쓰기',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    bool isDark,
    Color cardColor,
  ) {
    final categories = ['동네질문', '동네맛집', '동네소식', '취미생활', '분실/실종', '해주세요', '일상'];
    final chipBgColor = isDark ? Colors.grey[800] : Colors.grey[100];
    final chipTextColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: cardColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(category),
                backgroundColor: chipBgColor,
                labelStyle: TextStyle(fontSize: 14, color: chipTextColor),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('$category 카테고리')));
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPostList(BuildContext context, bool isDark, Color cardColor) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final dividerColor = isDark ? Colors.grey[800] : const Color(0xFFE5E5E5);

    final posts = [
      {
        'category': '동네질문',
        'title': '이 동네 맛집 추천해주세요!',
        'content': '이사온지 얼마 안됐는데 맛집 추천 부탁드려요~',
        'location': '아라동',
        'time': '10분 전',
        'likes': 5,
        'comments': 12,
      },
      {
        'category': '동네소식',
        'title': '주말에 아라동 축제 한다고 하네요',
        'content': '이번 주말에 동네 축제가 열린다고 합니다. 다들 오세요!',
        'location': '아라동',
        'time': '30분 전',
        'likes': 23,
        'comments': 8,
      },
      {
        'category': '취미생활',
        'title': '같이 러닝하실 분 계신가요?',
        'content': '매주 토요일 아침에 같이 러닝하실 분 구해요.',
        'location': '아라동',
        'time': '1시간 전',
        'likes': 15,
        'comments': 20,
      },
    ];

    return Column(
      children: posts.map((post) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NeighborhoodPostDetailScreen(post: post),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(bottom: BorderSide(color: dividerColor!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post['category'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  post['title'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${post['location']} · ${post['time']}',
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_up_outlined,
                          size: 14,
                          color: subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post['likes']}',
                          style: TextStyle(fontSize: 12, color: subTextColor),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14,
                          color: subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post['comments']}',
                          style: TextStyle(fontSize: 12, color: subTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
