import '../models/product.dart';

/// 채팅방 데이터 모델
class ChatRoom {
  final String id;
  final String recipientId;
  final String recipientName;
  final Product product;
  final List<ChatMessage> messages;
  final DateTime lastMessageTime;
  int unreadCount;

  ChatRoom({
    required this.id,
    required this.recipientId,
    required this.recipientName,
    required this.product,
    required this.messages,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  String get lastMessage => messages.isNotEmpty ? messages.last.text : '';

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(lastMessageTime);

    if (diff.inMinutes < 1) return '방금';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays == 1) return '어제';
    return '${diff.inDays}일 전';
  }
}

/// 채팅 메시지 데이터 모델
class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });

  String get formattedTime {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$period $displayHour:$minute';
  }
}

/// 전역 채팅방 리스트
List<ChatRoom> chatRooms = [];

/// 채팅방 찾기 또는 생성
ChatRoom getOrCreateChatRoom(Product product) {
  // 기존 채팅방 찾기
  final existingRoom = chatRooms.firstWhere(
    (room) =>
        room.product.id == product.id && room.recipientId == product.userId,
    orElse: () => _createNewChatRoom(product),
  );

  // 새로 생성된 경우 리스트에 추가
  if (!chatRooms.contains(existingRoom)) {
    chatRooms.insert(0, existingRoom);
  }

  return existingRoom;
}

/// 새 채팅방 생성
ChatRoom _createNewChatRoom(Product product) {
  final now = DateTime.now();
  return ChatRoom(
    id: 'chat_${now.millisecondsSinceEpoch}',
    recipientId: product.userId,
    recipientName: product.sellerName,
    product: product,
    messages: [],
    lastMessageTime: now,
  );
}

/// 메시지 전송
void sendMessage(ChatRoom room, String text) {
  final message = ChatMessage(
    id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
    text: text,
    isMe: true,
    time: DateTime.now(),
  );
  room.messages.add(message);

  // 채팅방 순서 업데이트 (최신이 맨 위)
  chatRooms.remove(room);
  chatRooms.insert(0, room);

  // 자동 응답 시뮬레이션 (1초 후)
  Future.delayed(const Duration(seconds: 1), () {
    final autoReply = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: _getAutoReply(),
      isMe: false,
      time: DateTime.now(),
    );
    room.messages.add(autoReply);
  });
}

/// 자동 응답 메시지
String _getAutoReply() {
  final replies = [
    '네, 알겠습니다!',
    '좋아요, 그렇게 해요.',
    '거래 가능합니다~',
    '오늘 시간 되세요?',
    '어디서 만날까요?',
  ];
  return replies[DateTime.now().millisecond % replies.length];
}
