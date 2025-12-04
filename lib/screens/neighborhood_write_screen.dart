import 'package:flutter/material.dart';

class NeighborhoodWriteScreen extends StatefulWidget {
  const NeighborhoodWriteScreen({super.key});

  @override
  State<NeighborhoodWriteScreen> createState() =>
      _NeighborhoodWriteScreenState();
}

class _NeighborhoodWriteScreenState extends State<NeighborhoodWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedTopic;

  final List<String> _topics = [
    '동네질문',
    '동네맛집',
    '동네소식',
    '취미생활',
    '분실/실종',
    '해주세요',
    '일상',
  ];

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
        title: Text('동네생활 글쓰기', style: TextStyle(color: textColor)),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: _submitPost,
            child: const Text(
              '완료',
              style: TextStyle(
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
                maxLines: 15,
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
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('사진 추가')));
              },
              icon: Icon(Icons.photo_outlined, color: iconColor),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('장소 추가')));
              },
              icon: Icon(Icons.location_on_outlined, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }

  void _showTopicPicker(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

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
              ..._topics.map((topic) {
                final isSelected = topic == _selectedTopic;
                return ListTile(
                  title: Text(
                    topic,
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
                      _selectedTopic = topic;
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('글이 등록되었습니다!')));
    Navigator.pop(context);
  }
}
