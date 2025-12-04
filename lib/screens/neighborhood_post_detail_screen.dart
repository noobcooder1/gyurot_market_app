import 'package:flutter/material.dart';

class NeighborhoodPostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const NeighborhoodPostDetailScreen({super.key, required this.post});

  @override
  State<NeighborhoodPostDetailScreen> createState() =>
      _NeighborhoodPostDetailScreenState();
}

class _NeighborhoodPostDetailScreenState
    extends State<NeighborhoodPostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool isLiked = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

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
        title: Text('동네생활', style: TextStyle(color: textColor)),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () {
              _showMoreOptions(context, isDark);
            },
            icon: Icon(Icons.more_vert, color: iconColor),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 작성자 정보
                  Container(
                    color: cardColor,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: isDark
                              ? Colors.grey[700]
                              : Colors.grey[200],
                          child: Icon(
                            Icons.person,
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '동네주민',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                '${widget.post['location']} · ${widget.post['time']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            widget.post['category'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 게시글 내용
                  Container(
                    color: cardColor,
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post['title'] as String,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.post['content'] as String? ??
                              '게시글 내용이 여기에 표시됩니다.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 좋아요/댓글 수
                  Container(
                    color: cardColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                size: 20,
                                color: isLiked
                                    ? const Color(0xFFFF6F0F)
                                    : subTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '공감 ${widget.post['likes']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 20,
                              color: subTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '댓글 ${widget.post['comments']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 8,
                    thickness: 8,
                    color: isDark ? Colors.black : const Color(0xFFF5F5F5),
                  ),

                  // 댓글 목록
                  Container(
                    color: cardColor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '댓글',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildComment(
                          context,
                          isDark,
                          '이웃1',
                          '좋은 정보 감사합니다!',
                          '5분 전',
                        ),
                        _buildComment(
                          context,
                          isDark,
                          '이웃2',
                          '저도 궁금했어요~',
                          '10분 전',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 댓글 입력
          Container(
            color: cardColor,
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      hintStyle: TextStyle(color: subTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFFFF6F0F)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('댓글이 등록되었습니다.')),
                      );
                      _commentController.clear();
                    }
                  },
                  icon: const Icon(Icons.send, color: Color(0xFFFF6F0F)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(
    BuildContext context,
    bool isDark,
    String name,
    String content,
    String time,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
            child: Icon(
              Icons.person,
              size: 18,
              color: isDark ? Colors.grey[400] : Colors.grey,
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
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(content, style: TextStyle(fontSize: 14, color: textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('공유하기'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('공유하기')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.report_outlined),
                title: const Text('신고하기'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('신고하기')));
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
