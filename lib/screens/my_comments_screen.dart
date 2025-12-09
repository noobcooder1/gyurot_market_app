import 'package:flutter/material.dart';
import '../data/neighborhood_data.dart';
import 'neighborhood_post_detail_screen.dart';

/// 내가 작성한 동네생활 댓글 화면
class MyCommentsScreen extends StatefulWidget {
  const MyCommentsScreen({super.key});

  @override
  State<MyCommentsScreen> createState() => _MyCommentsScreenState();
}

class _MyCommentsScreenState extends State<MyCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    // 전역 리스트에서 내가 작성한 댓글 가져오기
    final myComments = myNeighborhoodComments;

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
                return InkWell(
                  onTap: () {
                    // 해당 게시글로 이동
                    if (comment.postId != null) {
                      final post = neighborhoodPosts.firstWhere(
                        (p) => p.id == comment.postId,
                        orElse: () => neighborhoodPosts.first,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NeighborhoodPostDetailScreen(
                            post: {
                              'neighborhoodPost': post,
                              'title': post.title,
                              'content': post.content,
                              'category': post.category,
                              'location': post.location,
                              'time': post.formattedTime,
                              'likes': post.likes,
                            },
                          ),
                        ),
                      ).then((_) {
                        // 돌아왔을 때 화면 새로고침
                        setState(() {});
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 게시글 제목 표시
                        if (comment.postTitle != null) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 14,
                                color: subTextColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  comment.postTitle!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: subTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        // 댓글 내용
                        Text(
                          comment.content,
                          style: TextStyle(fontSize: 14, color: textColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // 작성 시간
                        Text(
                          comment.formattedTime,
                          style: TextStyle(fontSize: 12, color: subTextColor),
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
