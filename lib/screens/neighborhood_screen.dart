import 'package:flutter/material.dart';
import '../data/neighborhood_data.dart';
import 'neighborhood_post_detail_screen.dart';
import 'neighborhood_write_screen.dart';
import 'notification_screen.dart';
import 'neighborhood_search_screen.dart';

class NeighborhoodScreen extends StatefulWidget {
  const NeighborhoodScreen({super.key});

  @override
  State<NeighborhoodScreen> createState() => _NeighborhoodScreenState();
}

class _NeighborhoodScreenState extends State<NeighborhoodScreen> {
  String? _selectedCategory;

  final List<String> _categories = [
    '동네질문',
    '동네맛집',
    '동네소식',
    '취미생활',
    '분실/실종',
    '해주세요',
    '일상',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final filteredPosts = _selectedCategory == null
        ? neighborhoodPosts
        : neighborhoodPosts
              .where((p) => p.category == _selectedCategory)
              .toList();

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NeighborhoodSearchScreen(),
                ),
              );
            },
            icon: Icon(Icons.search, color: iconColor),
            tooltip: '검색',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
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
          _buildPostList(context, isDark, cardColor, filteredPosts),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => const NeighborhoodWriteScreen(),
            ),
          );
          if (result == true && mounted) {
            setState(() {});
          }
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
    final chipBgColor = isDark ? Colors.grey[800] : Colors.grey[100];
    final chipTextColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: cardColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // 전체 카테고리
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: const Text('전체'),
                backgroundColor: _selectedCategory == null
                    ? const Color(0xFFFF6F0F)
                    : chipBgColor,
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: _selectedCategory == null
                      ? Colors.white
                      : chipTextColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                },
              ),
            ),
            ..._categories.map((category) {
              final isSelected = category == _selectedCategory;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(category),
                  backgroundColor: isSelected
                      ? const Color(0xFFFF6F0F)
                      : chipBgColor,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : chipTextColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  onPressed: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(
    BuildContext context,
    bool isDark,
    Color cardColor,
    List<NeighborhoodPost> posts,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final dividerColor = isDark ? Colors.grey[800] : const Color(0xFFE5E5E5);

    if (posts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              Icon(
                Icons.article_outlined,
                size: 48,
                color: isDark ? Colors.grey[600] : Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text('아직 게시글이 없습니다', style: TextStyle(color: subTextColor)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: posts.map((post) {
        return InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NeighborhoodPostDetailScreen(
                  post: {
                    'id': post.id,
                    'category': post.category,
                    'title': post.title,
                    'content': post.content,
                    'authorName': post.authorName,
                    'location': post.location,
                    'time': post.formattedTime,
                    'likes': post.likes,
                    'comments': post.comments.length,
                    'neighborhoodPost': post,
                  },
                ),
              ),
            );
            // 돌아왔을 때 UI 갱신 (좋아요, 댓글 등)
            setState(() {});
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
                        post.category,
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
                  post.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: subTextColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${post.location} · ${post.formattedTime}',
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          post.isLiked
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          size: 14,
                          color: post.isLiked
                              ? const Color(0xFFFF6F0F)
                              : subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.likes}',
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
                          '${post.comments.length}',
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
