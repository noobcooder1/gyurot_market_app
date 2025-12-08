import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../data/neighborhood_data.dart';
import 'neighborhood_write_screen.dart';

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
  NeighborhoodPost? _neighborhoodPost;
  int _currentImageIndex = 0;
  final PageController _imagePageController = PageController();

  @override
  void initState() {
    super.initState();
    _neighborhoodPost = widget.post['neighborhoodPost'] as NeighborhoodPost?;
  }

  @override
  void dispose() {
    _commentController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    if (_neighborhoodPost != null) {
      setState(() {
        toggleLike(_neighborhoodPost!);
      });
    }
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    if (_neighborhoodPost != null) {
      setState(() {
        addComment(_neighborhoodPost!, _commentController.text, '나');
      });
      _commentController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('댓글이 등록되었습니다.')));
    }
  }

  // 전체 화면 이미지 뷰어 열기
  void _openFullScreenViewer(int initialIndex) {
    if (_neighborhoodPost?.images == null || _neighborhoodPost!.images!.isEmpty)
      return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _NeighborhoodFullScreenImageViewer(
          images: _neighborhoodPost!.images!,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    final isLiked = _neighborhoodPost?.isLiked ?? false;
    final likes =
        _neighborhoodPost?.likes ?? (widget.post['likes'] as int? ?? 0);
    final comments = _neighborhoodPost?.comments ?? [];
    final authorName = _neighborhoodPost?.authorName ?? '동네주민';

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
                          child: Text(
                            authorName.substring(0, 1),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authorName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                '${widget.post['location']} · ${_neighborhoodPost?.formattedTime ?? widget.post['time']}',
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
                          _neighborhoodPost?.content ??
                              widget.post['content'] as String? ??
                              '게시글 내용이 여기에 표시됩니다.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: textColor,
                          ),
                        ),
                        // 첨부 이미지 표시 - PageView 슬라이더 방식
                        if (_neighborhoodPost?.images != null &&
                            _neighborhoodPost!.images!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 300,
                              child: Stack(
                                children: [
                                  // PageView 이미지 슬라이더
                                  PageView.builder(
                                    controller: _imagePageController,
                                    itemCount:
                                        _neighborhoodPost!.images!.length,
                                    physics: const ClampingScrollPhysics(),
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentImageIndex = index;
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () =>
                                            _openFullScreenViewer(index),
                                        child: Image.memory(
                                          _neighborhoodPost!.images![index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      size: 48,
                                                    ),
                                                  ),
                                                );
                                              },
                                        ),
                                      );
                                    },
                                  ),
                                  // 좌측 화살표 버튼
                                  if (_neighborhoodPost!.images!.length > 1 &&
                                      _currentImageIndex > 0)
                                    Positioned(
                                      left: 8,
                                      top: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          _imagePageController.previousPage(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: Container(
                                          width: 40,
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(
                                                alpha: 0.4,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.chevron_left,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  // 우측 화살표 버튼
                                  if (_neighborhoodPost!.images!.length > 1 &&
                                      _currentImageIndex <
                                          _neighborhoodPost!.images!.length - 1)
                                    Positioned(
                                      right: 8,
                                      top: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          _imagePageController.nextPage(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: Container(
                                          width: 40,
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(
                                                alpha: 0.4,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.chevron_right,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  // 페이지 인디케이터 (1 / 3)
                                  if (_neighborhoodPost!.images!.length > 1)
                                    Positioned(
                                      bottom: 12,
                                      right: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${_currentImageIndex + 1} / ${_neighborhoodPost!.images!.length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                          onTap: _toggleLike,
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
                                '공감 $likes',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isLiked
                                      ? const Color(0xFFFF6F0F)
                                      : subTextColor,
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
                              '댓글 ${comments.length}',
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
                          '댓글 ${comments.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (comments.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                '첫 번째 댓글을 남겨보세요!',
                                style: TextStyle(color: subTextColor),
                              ),
                            ),
                          )
                        else
                          ...comments.map(
                            (comment) => _buildComment(
                              context,
                              isDark,
                              comment.authorName,
                              comment.content,
                              comment.formattedTime,
                            ),
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
                    onSubmitted: (_) => _addComment(),
                  ),
                ),
                IconButton(
                  onPressed: _addComment,
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
            child: Text(
              name.substring(0, 1),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey[600],
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
    final textColor = isDark ? Colors.white : Colors.black;

    // 내 글인지 확인 (authorName이 '나'인 경우)
    final authorName = _neighborhoodPost?.authorName ?? '동네주민';
    final isMyPost = authorName == '나';

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
                leading: Icon(Icons.share_outlined, color: textColor),
                title: Text('공유하기', style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(context);
                  _sharePost();
                },
              ),
              if (isMyPost) ...[
                ListTile(
                  leading: Icon(Icons.edit_outlined, color: textColor),
                  title: Text('수정하기', style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.pop(context);
                    _editPost();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outlined, color: Colors.red),
                  title: const Text(
                    '삭제하기',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _deletePost(isDark);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.report_outlined, color: Colors.red),
                  title: const Text(
                    '신고하기',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog(context, isDark);
                  },
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _editPost() async {
    if (_neighborhoodPost == null) return;

    // NeighborhoodWriteScreen으로 이동하여 전체 화면에서 수정
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NeighborhoodWriteScreen(editPost: _neighborhoodPost),
      ),
    );

    if (result == true) {
      // 수정 후 상세 화면을 닫고 목록으로 돌아가서 새로고침
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void _deletePost(bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        title: Text('게시글 삭제', style: TextStyle(color: textColor)),
        content: Text(
          '정말 이 게시글을 삭제하시겠습니까?',
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_neighborhoodPost != null) {
                neighborhoodPosts.removeWhere(
                  (p) => p.id == _neighborhoodPost!.id,
                );
              }
              Navigator.pop(context);
              Navigator.pop(context);
              Get.snackbar('완료', '게시글이 삭제되었습니다');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _sharePost() async {
    final title = widget.post['title'] as String;
    final content = _neighborhoodPost?.content ?? '';
    final location = widget.post['location'] as String? ?? '아라동';

    final shareText =
        '''
📢 동네생활 게시글

제목: $title

$content

📍 위치: $location
🏠 당근마켓에서 확인하세요!
''';

    try {
      await Share.share(shareText, subject: title);
    } catch (e) {
      Get.snackbar('오류', '공유하기에 실패했습니다.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _showReportDialog(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    final reasons = [
      '광고성 콘텐츠예요',
      '부적절한 내용이에요',
      '욕설/비방이 포함되어 있어요',
      '개인정보가 노출되어 있어요',
      '다른 문제가 있어요',
    ];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '신고 사유를 선택해주세요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              ...reasons.map(
                (reason) => ListTile(
                  title: Text(reason, style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.pop(context);
                    if (reason == '다른 문제가 있어요') {
                      _showOtherReportDialog(context, isDark);
                    } else {
                      Get.snackbar(
                        '신고 접수',
                        '신고가 접수되었습니다. 검토 후 조치하겠습니다.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showOtherReportDialog(BuildContext context, bool isDark) {
    final TextEditingController reportController = TextEditingController();
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: Text('신고 사유 입력', style: TextStyle(color: textColor)),
          content: TextField(
            controller: reportController,
            maxLines: 4,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: '다른 문제가 있다면 자세히 적어주세요.',
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[400],
              ),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (reportController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  Get.snackbar(
                    '신고 접수',
                    '신고가 접수되었습니다. 검토 후 조치하겠습니다.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Get.snackbar(
                    '알림',
                    '신고 사유를 입력해주세요.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('신고하기', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

// 동네생활 전용 전체 화면 이미지 뷰어 위젯
class _NeighborhoodFullScreenImageViewer extends StatefulWidget {
  final List<dynamic> images;
  final int initialIndex;

  const _NeighborhoodFullScreenImageViewer({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_NeighborhoodFullScreenImageViewer> createState() =>
      _NeighborhoodFullScreenImageViewerState();
}

class _NeighborhoodFullScreenImageViewerState
    extends State<_NeighborhoodFullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 이미지 PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.memory(
                    widget.images[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 64,
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // 닫기 버튼
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),

          // 좌측 화살표 버튼
          if (widget.images.length > 1 && _currentIndex > 0)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

          // 우측 화살표 버튼
          if (widget.images.length > 1 &&
              _currentIndex < widget.images.length - 1)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

          // 페이지 인디케이터 (점)
          if (widget.images.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 10 : 8,
                    height: _currentIndex == index ? 10 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
