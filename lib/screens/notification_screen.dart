import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> activityNotifications = [
    {
      'type': 'like',
      'title': '관심 상품 가격이 내려갔어요',
      'message': '아이폰 12 프로 가격이 700,000원으로 변경되었습니다.',
      'time': '10분 전',
      'isRead': false,
    },
    {
      'type': 'chat',
      'title': '새로운 채팅이 왔어요',
      'message': '김철수님이 메시지를 보냈습니다.',
      'time': '30분 전',
      'isRead': false,
    },
    {
      'type': 'deal',
      'title': '거래가 완료되었어요',
      'message': '니콘 D5300 렌즈포함 거래가 완료되었습니다.',
      'time': '2시간 전',
      'isRead': true,
    },
    {
      'type': 'review',
      'title': '거래 후기가 도착했어요',
      'message': '이영희님이 거래 후기를 남겼습니다.',
      'time': '1일 전',
      'isRead': true,
    },
  ];

  final List<Map<String, dynamic>> keywordNotifications = [
    {
      'keyword': '아이폰',
      'title': '새로운 아이폰 상품이 등록되었어요',
      'message': '아이폰 14 프로맥스 256GB',
      'time': '5분 전',
      'isRead': false,
    },
    {
      'keyword': '맥북',
      'title': '새로운 맥북 상품이 등록되었어요',
      'message': '맥북 프로 14인치 M3',
      'time': '1시간 전',
      'isRead': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('알림'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDark ? Colors.white : Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFF6F0F),
          tabs: const [
            Tab(text: '활동 알림'),
            Tab(text: '키워드 알림'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivityNotifications(isDark),
          _buildKeywordNotifications(isDark),
        ],
      ),
    );
  }

  Widget _buildActivityNotifications(bool isDark) {
    if (activityNotifications.isEmpty) {
      return _buildEmptyState('활동 알림이 없습니다');
    }

    return ListView.separated(
      itemCount: activityNotifications.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notification = activityNotifications[index];
        return _buildNotificationItem(notification, isDark);
      },
    );
  }

  Widget _buildKeywordNotifications(bool isDark) {
    if (keywordNotifications.isEmpty) {
      return _buildEmptyState('키워드 알림이 없습니다');
    }

    return ListView.separated(
      itemCount: keywordNotifications.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notification = keywordNotifications[index];
        return _buildNotificationItem(notification, isDark, isKeyword: true);
      },
    );
  }

  Widget _buildNotificationItem(
    Map<String, dynamic> notification,
    bool isDark, {
    bool isKeyword = false,
  }) {
    IconData icon;
    Color iconBgColor;

    if (isKeyword) {
      icon = Icons.tag;
      iconBgColor = Colors.blue;
    } else {
      switch (notification['type']) {
        case 'like':
          icon = Icons.favorite;
          iconBgColor = Colors.red;
          break;
        case 'chat':
          icon = Icons.chat_bubble;
          iconBgColor = const Color(0xFFFF6F0F);
          break;
        case 'deal':
          icon = Icons.handshake;
          iconBgColor = Colors.green;
          break;
        case 'review':
          icon = Icons.star;
          iconBgColor = Colors.amber;
          break;
        default:
          icon = Icons.notifications;
          iconBgColor = Colors.grey;
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          notification['isRead'] = true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(notification['message'])));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: notification['isRead']
            ? (isDark ? Colors.transparent : Colors.transparent)
            : (isDark ? Colors.grey[900] : const Color(0xFFFFF8F0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isKeyword)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#${notification['keyword']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Text(
                    notification['title'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
