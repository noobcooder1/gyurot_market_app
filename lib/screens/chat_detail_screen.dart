import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/chat_data.dart';
import '../data/user_preferences.dart';
import 'product_detail_screen.dart';
import 'package:image_picker/image_picker.dart';

class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatRoom? _chatRoom;

  @override
  void initState() {
    super.initState();
    // chat에 chatRoom이 있으면 사용, 없으면 기존 방식
    if (widget.chat['chatRoom'] != null) {
      _chatRoom = widget.chat['chatRoom'] as ChatRoom;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final ImagePicker _imagePicker = ImagePicker();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedLocation;

  /// 약속잡기 다이얼로그
  void _showAppointmentDialog() {
    _selectedDate = null;
    _selectedTime = null;
    _selectedLocation = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
            final textColor = isDark ? Colors.white : Colors.black;
            final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

            return Container(
              color: bgColor,
              padding: const EdgeInsets.all(20),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '거래 약속 잡기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // 날짜 선택
                    ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: const Color(0xFFFF6F0F),
                      ),
                      title: Text('날짜', style: TextStyle(color: textColor)),
                      subtitle: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일'
                            : '날짜를 선택해주세요',
                        style: TextStyle(color: subTextColor),
                      ),
                      trailing: Icon(Icons.chevron_right, color: subTextColor),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                        );
                        if (date != null) {
                          setModalState(() => _selectedDate = date);
                        }
                      },
                    ),
                    Divider(
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                    // 시간 선택
                    ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: const Color(0xFFFF6F0F),
                      ),
                      title: Text('시간', style: TextStyle(color: textColor)),
                      subtitle: Text(
                        _selectedTime != null
                            ? '${_selectedTime!.hour}시 ${_selectedTime!.minute}분'
                            : '시간을 선택해주세요',
                        style: TextStyle(color: subTextColor),
                      ),
                      trailing: Icon(Icons.chevron_right, color: subTextColor),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setModalState(() => _selectedTime = time);
                        }
                      },
                    ),
                    Divider(
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                    // 장소 선택
                    ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: const Color(0xFFFF6F0F),
                      ),
                      title: Text('장소', style: TextStyle(color: textColor)),
                      subtitle: Text(
                        _selectedLocation ?? '장소를 선택해주세요',
                        style: TextStyle(color: subTextColor),
                      ),
                      trailing: Icon(Icons.chevron_right, color: subTextColor),
                      onTap: () => _showLocationPicker(setModalState),
                    ),
                    const SizedBox(height: 24),
                    // 확인 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (_selectedDate != null &&
                                _selectedTime != null &&
                                _selectedLocation != null)
                            ? () {
                                Navigator.pop(context);
                                _sendAppointmentMessage();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6F0F),
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '약속 잡기',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLocationPicker(StateSetter setModalState) {
    final locations = [
      '아라동 주민센터 앞',
      '제주시청 앞',
      '이마트 아라점',
      '편의점 앞',
      '아라시장',
      '기타 장소 직접 입력',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;

        return SafeArea(
          child: Container(
            color: bgColor,
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
                ...locations.map(
                  (location) => ListTile(
                    title: Text(location, style: TextStyle(color: textColor)),
                    onTap: () {
                      Navigator.pop(context);
                      if (location == '기타 장소 직접 입력') {
                        _showCustomLocationInput(setModalState);
                      } else {
                        setModalState(() => _selectedLocation = location);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCustomLocationInput(StateSetter setModalState) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('장소 입력'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '장소를 입력해주세요'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  setModalState(
                    () => _selectedLocation = controller.text.trim(),
                  );
                }
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _sendAppointmentMessage() {
    if (_selectedDate == null ||
        _selectedTime == null ||
        _selectedLocation == null)
      return;

    final message =
        '📅 거래 약속\n'
        '날짜: ${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일\n'
        '시간: ${_selectedTime!.hour}시 ${_selectedTime!.minute}분\n'
        '장소: $_selectedLocation';

    setState(() {
      if (_chatRoom != null) {
        sendMessage(_chatRoom!, message);
      }
    });

    Get.snackbar('약속', '거래 약속이 전송되었습니다');
  }

  /// 첨부 메뉴 표시
  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;

        return Container(
          color: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentItem(
                      Icons.photo_library,
                      '앨범',
                      Colors.orange,
                      () => _pickImageFromGallery(),
                      textColor,
                    ),
                    _buildAttachmentItem(
                      Icons.camera_alt,
                      '카메라',
                      Colors.blue,
                      () => _pickImageFromCamera(),
                      textColor,
                    ),
                    _buildAttachmentItem(
                      Icons.payment,
                      '밤톨페이',
                      Colors.amber,
                      () => _showGyurotPay(),
                      textColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentItem(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: textColor)),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          if (_chatRoom != null) {
            sendMessage(_chatRoom!, '[이미지 전송]');
          }
        });
        Get.snackbar('완료', '이미지가 전송되었습니다');
      }
    } catch (e) {
      Get.snackbar('오류', '이미지를 가져올 수 없습니다');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          if (_chatRoom != null) {
            sendMessage(_chatRoom!, '[사진 전송]');
          }
        });
        Get.snackbar('완료', '사진이 전송되었습니다');
      }
    } catch (e) {
      Get.snackbar('오류', '카메라를 사용할 수 없습니다');
    }
  }

  void _showGyurotPay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('밤톨페이'),
        content: Text(
          '밤톨페이로 안전하게 결제할 수 있습니다.\n\n금액: ${_chatRoom?.product.price ?? "가격 미정"}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (_chatRoom != null) {
                  sendMessage(_chatRoom!, '💳 밤톨페이 결제 요청');
                }
              });
              Get.snackbar('완료', '결제 요청이 전송되었습니다');
            },
            child: const Text('결제 요청'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      if (_chatRoom != null) {
        // 전역 데이터에 메시지 추가
        sendMessage(_chatRoom!, _messageController.text);
      }
    });
    _messageController.clear();

    // 스크롤을 맨 아래로
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // 자동 응답 후 UI 갱신
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final messages = _chatRoom?.messages ?? [];
    final productTitle = widget.chat['product'] as String? ?? '상품';

    // 차단 상태 확인
    final recipientId = _chatRoom?.recipientId ?? 'user_${widget.chat['id']}';
    final isBlocked = isUserBlocked(recipientId);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chat['name'] as String? ?? '사용자',
              style: TextStyle(fontSize: 16, color: iconColor),
            ),
            Text(
              productTitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: iconColor),
            onPressed: () => _showChatOptions(context),
          ),
        ],
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 상품 정보 배너
          InkWell(
            onTap: () {
              // 상품 상세 화면으로 이동
              if (_chatRoom != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(product: _chatRoom!.product),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              color: cardColor,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _chatRoom?.product.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _chatRoom!.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image, color: Colors.grey[500]),
                            ),
                          )
                        : Icon(Icons.image, color: Colors.grey[500]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productTitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          _chatRoom?.product.price ?? '가격 미정',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF6F0F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _showAppointmentDialog,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF6F0F),
                      side: const BorderSide(color: Color(0xFFFF6F0F)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('약속잡기'),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),

          // 메시지 목록
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '메시지를 보내 대화를 시작하세요!',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(message, isDark);
                    },
                  ),
          ),

          // 메시지 입력 (차단된 경우 안내 메시지 표시)
          if (isBlocked)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.block, color: Colors.grey[500], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '차단한 사용자와는 대화할 수 없습니다.',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add, color: iconColor),
                      onPressed: _showAttachmentMenu,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: '메시지를 입력하세요',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          filled: true,
                          fillColor: isDark
                              ? Colors.grey[800]
                              : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFFFF6F0F)),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isDark) {
    final bool isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
              child: Text(
                (widget.chat['name'] as String? ?? 'U').substring(0, 1),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (isMe)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                message.formattedTime,
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe
                  ? const Color(0xFFFF6F0F)
                  : (isDark ? Colors.grey[800] : Colors.white),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                color: isMe
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ),
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                message.formattedTime,
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ),
        ],
      ),
    );
  }

  void _showChatOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final chatId = _chatRoom?.id ?? widget.chat['id'] as String? ?? '';
    final notificationEnabled = getChatNotificationEnabled(chatId);

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
                leading: Icon(
                  notificationEnabled
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_outlined,
                ),
                title: Text(notificationEnabled ? '알림 끄기' : '알림 켜기'),
                onTap: () {
                  Navigator.pop(context);
                  final newState = toggleChatNotification(chatId);
                  Get.snackbar(
                    '알림 설정',
                    newState ? '채팅 알림이 켜졌습니다' : '채팅 알림이 꺼졌습니다',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              // 이미 차단된 사용자가 아닌 경우에만 차단 버튼 표시
              if (!isUserBlocked(
                _chatRoom?.recipientId ?? 'user_${widget.chat['id']}',
              ))
                ListTile(
                  leading: const Icon(Icons.block_outlined),
                  title: const Text('이 사용자 차단하기'),
                  onTap: () {
                    Navigator.pop(context);
                    _showBlockUserDialog(context, isDark);
                  },
                )
              else
                ListTile(
                  leading: Icon(Icons.block, color: Colors.grey[500]),
                  title: Text(
                    '차단된 사용자입니다',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  subtitle: Text(
                    '설정 > 차단한 사용자 관리에서 해제할 수 있습니다',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.red),
                title: const Text('신고하기', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context, isDark);
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text(
                  '채팅방 나가기',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showLeaveChatDialog(context, isDark);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showBlockUserDialog(BuildContext context, bool isDark) {
    final userName = widget.chat['name'] as String? ?? '사용자';
    // 올바른 사용자 ID 사용 (chatRoom에서 recipientId 가져오기)
    final userId = _chatRoom?.recipientId ?? 'user_unknown';
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: Text('사용자 차단', style: TextStyle(color: textColor)),
          content: Text(
            '$userName님을 차단하시겠습니까?\n\n차단하면 해당 사용자와 대화할 수 없으며, 상대방은 귀하의 게시글을 볼 수 없습니다.\n\n설정 > 차단한 사용자 관리에서 해제할 수 있습니다.',
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                blockUser(userId, userName);
                Navigator.pop(context);
                Navigator.pop(context); // 채팅방도 나가기
                Get.snackbar(
                  '차단 완료',
                  '$userName님을 차단했습니다',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('차단하기', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    final reasons = ['스팸/사기 같아요', '욕설/비방을 해요', '불쾌한 대화를 해요', '다른 문제가 있어요'];

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

  void _showLeaveChatDialog(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: Text('채팅방 나가기', style: TextStyle(color: textColor)),
          content: Text(
            '채팅방을 나가시겠습니까?\n\n나가면 대화 내용이 모두 삭제되며 복구할 수 없습니다.',
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 채팅방 삭제
                if (_chatRoom != null) {
                  chatRooms.removeWhere((room) => room.id == _chatRoom!.id);
                }
                Navigator.pop(context);
                Navigator.pop(context);
                Get.snackbar(
                  '완료',
                  '채팅방을 나갔습니다',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('나가기', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
