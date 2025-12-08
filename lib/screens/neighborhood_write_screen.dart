import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/neighborhood_data.dart';

class NeighborhoodWriteScreen extends StatefulWidget {
  final NeighborhoodPost? editPost; // 수정할 글 (null이면 신규 등록)

  const NeighborhoodWriteScreen({super.key, this.editPost});

  @override
  State<NeighborhoodWriteScreen> createState() =>
      _NeighborhoodWriteScreenState();
}

class _NeighborhoodWriteScreenState extends State<NeighborhoodWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedTopic;
  final List<Uint8List> _images = [];
  String? _selectedLocation;
  final ImagePicker _picker = ImagePicker();

  bool get _isEditMode => widget.editPost != null;

  final List<String> _topics = ['동네정보', '취미 및 일상', '분실/실종', '일반'];

  final List<String> _locations = ['아라동', '연동', '노형동', '이도동', '삼도동', '용담동'];

  @override
  void initState() {
    super.initState();
    // 수정 모드인 경우 기존 데이터로 초기화
    if (widget.editPost != null) {
      final post = widget.editPost!;
      _titleController.text = post.title;
      _contentController.text = post.content;
      _selectedTopic = post.category;
      _selectedLocation = post.location;
      if (post.images != null) {
        _images.addAll(post.images!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[400];
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[300];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: iconColor),
        ),
        title: Text(
          _isEditMode ? '게시글 수정' : '동네생활 글쓰기',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: _submitPost,
            child: Text(
              _isEditMode ? '수정' : '완료',
              style: const TextStyle(
                color: Color(0xFFFF6F0F),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 주제 선택
            Container(
              color: cardColor,
              child: ListTile(
                title: Text(
                  _selectedTopic ?? '주제를 선택해주세요',
                  style: TextStyle(
                    color: _selectedTopic != null ? textColor : hintColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: hintColor),
                onTap: () => _showTopicPicker(context, isDark),
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // 제목
            Container(
              color: cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _titleController,
                style: TextStyle(color: textColor, fontSize: 18),
                decoration: InputDecoration(
                  hintText: '제목을 입력하세요',
                  hintStyle: TextStyle(color: hintColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // 내용
            Container(
              color: cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _contentController,
                maxLines: 10,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText:
                      '동네 이웃과 이야기를 나눠보세요.\n\n욕설, 비방 등 이웃을 불쾌하게 하는 글은 삭제될 수 있어요.',
                  hintStyle: TextStyle(color: hintColor, height: 1.5),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            // 첨부된 이미지 목록
            if (_images.isNotEmpty)
              Container(
                color: cardColor,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _images.asMap().entries.map((entry) {
                      return Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                entry.value,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: isDark
                                        ? Colors.grey[700]
                                        : Colors.grey[300],
                                    child: Center(
                                      child: Icon(
                                        Icons.image,
                                        color: isDark
                                            ? Colors.grey[500]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _images.removeAt(entry.key);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

            // 선택된 위치 표시
            if (_selectedLocation != null)
              Container(
                color: cardColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: const Color(0xFFFF6F0F),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedLocation!,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLocation = null;
                        });
                      },
                      child: Icon(Icons.close, size: 18, color: hintColor),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: cardColor,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 8,
          top: 8,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => _pickImage(context, isDark),
              icon: Icon(Icons.photo_outlined, color: iconColor),
              tooltip: '사진 추가',
            ),
            IconButton(
              onPressed: () => _pickLocation(context, isDark),
              icon: Icon(Icons.location_on_outlined, color: iconColor),
              tooltip: '장소 추가',
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(BuildContext context, bool isDark) {
    if (_images.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지는 최대 10장까지 추가할 수 있습니다.')),
      );
      return;
    }

    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (dialogContext) {
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '사진 추가',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: textColor),
                title: Text('카메라로 촬영', style: TextStyle(color: textColor)),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  try {
                    final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (pickedFile != null && mounted) {
                      final bytes = await pickedFile.readAsBytes();
                      setState(() {
                        _images.add(bytes);
                      });
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('카메라 오류: $e')));
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: textColor),
                title: Text('앨범에서 선택', style: TextStyle(color: textColor)),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  try {
                    final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (pickedFile != null && mounted) {
                      final bytes = await pickedFile.readAsBytes();
                      setState(() {
                        _images.add(bytes);
                      });
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('앨범 오류: $e')));
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _pickLocation(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      isScrollControlled: true,
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '장소 선택',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              ..._locations.map((location) {
                final isSelected = location == _selectedLocation;
                return ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: isSelected ? const Color(0xFFFF6F0F) : textColor,
                  ),
                  title: Text(
                    location,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFFF6F0F) : textColor,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Color(0xFFFF6F0F))
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLocation = location;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showTopicPicker(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      isScrollControlled: true, // 스크롤 가능하게
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: SafeArea(
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '주제 선택',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _topics.length,
                    itemBuilder: (context, index) {
                      final topic = _topics[index];
                      final isSelected = topic == _selectedTopic;
                      return ListTile(
                        title: Text(
                          topic,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFFFF6F0F)
                                : textColor,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Color(0xFFFF6F0F))
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedTopic = topic;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitPost() {
    if (_selectedTopic == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('주제를 선택해주세요.')));
      return;
    }
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('제목을 입력해주세요.')));
      return;
    }
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('내용을 입력해주세요.')));
      return;
    }
    if (_isEditMode) {
      // 수정 모드: 기존 글 업데이트
      final index = neighborhoodPosts.indexWhere(
        (p) => p.id == widget.editPost!.id,
      );
      if (index != -1) {
        neighborhoodPosts[index] = NeighborhoodPost(
          id: widget.editPost!.id,
          category: _selectedTopic!,
          title: _titleController.text,
          content: _contentController.text,
          authorName: widget.editPost!.authorName,
          location: _selectedLocation ?? widget.editPost!.location,
          createdAt: widget.editPost!.createdAt,
          images: _images.isNotEmpty
              ? List<Uint8List>.from(_images)
              : widget.editPost!.images,
          likes: widget.editPost!.likes,
          comments: widget.editPost!.comments,
          isLiked: widget.editPost!.isLiked,
        );
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('게시글이 수정되었습니다!')));
    } else {
      // 신규 등록 모드
      final newPost = NeighborhoodPost(
        id: 'post_${DateTime.now().millisecondsSinceEpoch}',
        category: _selectedTopic!,
        title: _titleController.text,
        content: _contentController.text,
        authorName: '나',
        location: _selectedLocation ?? '아라동',
        createdAt: DateTime.now(),
        images: _images.isNotEmpty ? List<Uint8List>.from(_images) : null,
      );
      addNeighborhoodPost(newPost);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('글이 등록되었습니다!')));
    }
    Navigator.pop(context, true);
  }
}
