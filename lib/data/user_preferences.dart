/// 사용자 설정 데이터 관리
/// 숨긴 판매자, 차단한 사용자, 채팅 알림 설정 등을 관리합니다.

// 숨긴 판매자 ID 목록
final Set<String> hiddenSellers = {};

// 차단한 사용자 ID 목록
final Set<String> blockedUsers = {};

// 채팅 알림 설정 (채팅방 ID -> 알림 활성화 여부)
final Map<String, bool> chatNotifications = {};

/// 숨긴 판매자 관리
class HiddenSellerInfo {
  final String id;
  final String name;
  final DateTime hiddenAt;

  HiddenSellerInfo({
    required this.id,
    required this.name,
    required this.hiddenAt,
  });
}

// 숨긴 판매자 정보 목록
final List<HiddenSellerInfo> hiddenSellerInfoList = [];

/// 판매자 숨기기 (중복 체크 포함)
void hideSeller(String sellerId, String sellerName) {
  // 이미 숨긴 판매자인지 확인
  if (hiddenSellers.contains(sellerId)) {
    return; // 이미 숨김
  }
  hiddenSellers.add(sellerId);
  hiddenSellerInfoList.add(
    HiddenSellerInfo(id: sellerId, name: sellerName, hiddenAt: DateTime.now()),
  );
}

/// 판매자 숨기기 해제
void unhideSeller(String sellerId) {
  hiddenSellers.remove(sellerId);
  hiddenSellerInfoList.removeWhere((info) => info.id == sellerId);
}

/// 판매자가 숨겨져 있는지 확인
bool isSellerHidden(String sellerId) {
  return hiddenSellers.contains(sellerId);
}

/// 차단한 사용자 관리
class BlockedUserInfo {
  final String id;
  final String name;
  final DateTime blockedAt;

  BlockedUserInfo({
    required this.id,
    required this.name,
    required this.blockedAt,
  });
}

// 차단한 사용자 정보 목록
final List<BlockedUserInfo> blockedUserInfoList = [];

/// 사용자 차단 (중복 체크 포함)
void blockUser(String userId, String userName) {
  // 이미 차단된 사용자인지 확인
  if (blockedUsers.contains(userId)) {
    return; // 이미 차단됨
  }
  blockedUsers.add(userId);
  blockedUserInfoList.add(
    BlockedUserInfo(id: userId, name: userName, blockedAt: DateTime.now()),
  );
}

/// 사용자 차단 해제
void unblockUser(String userId) {
  blockedUsers.remove(userId);
  blockedUserInfoList.removeWhere((info) => info.id == userId);
}

/// 사용자가 차단되어 있는지 확인
bool isUserBlocked(String userId) {
  return blockedUsers.contains(userId);
}

/// 채팅 알림 관리

/// 채팅방 알림 상태 가져오기 (기본값: 켜짐)
bool getChatNotificationEnabled(String chatId) {
  return chatNotifications[chatId] ?? true;
}

/// 채팅방 알림 상태 설정
void setChatNotificationEnabled(String chatId, bool enabled) {
  chatNotifications[chatId] = enabled;
}

/// 채팅방 알림 토글
bool toggleChatNotification(String chatId) {
  final current = getChatNotificationEnabled(chatId);
  setChatNotificationEnabled(chatId, !current);
  return !current;
}
