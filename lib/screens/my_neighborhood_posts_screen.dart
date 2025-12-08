import 'package:flutter/material.dart';
import '../data/neighborhood_data.dart';
import 'neighborhood_post_detail_screen.dart';

/// 내가 작성한 동네생활 글 화면
class MyNeighborhoodPostsScreen extends StatelessWidget {
  const MyNeighborhoodPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    // 내가 작성한 글만 필터 (authorName이 '나'인 경우)
    final myPosts = neighborhoodPosts
        .where((p) => p.authorName == '나')
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('동네생활 글'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: myPosts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: isDark ? Colors.grey[600] : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '작성한 글이 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: myPosts.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDark ? Colors.grey[800] : Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final post = myPosts[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NeighborhoodPostDetailScreen(
                          post: {
                            'id': post.id,
                            'category': post.category,
                            'title': post.title,
                            'content': post.content,
                            'author': post.authorName,
                            'location': post.location,
                            'time': post.formattedTime,
                            'likes': post.likes,
                            'comments': post.comments.length,
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: cardColor,
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
                                color: const Color(0xFFFF6F0F).withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                post.category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFFF6F0F),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              post.formattedTime,
                              style: TextStyle(
                                fontSize: 12,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.content,
                          style: TextStyle(fontSize: 14, color: textColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 16,
                              color: subTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${post.likes}',
                              style: TextStyle(
                                fontSize: 12,
                                color: subTextColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 16,
                              color: subTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${post.comments.length}',
                              style: TextStyle(
                                fontSize: 12,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
