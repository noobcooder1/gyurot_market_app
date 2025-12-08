import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../models/user_profile.dart';
import 'settings_screen.dart';
import 'profile_edit_screen.dart';
import 'sales_history_screen.dart';
import 'purchase_history_screen.dart';
import 'favorite_products_screen.dart';
import 'faq_screen.dart';
import 'my_neighborhood_posts_screen.dart';
import 'my_comments_screen.dart';
import 'manner_review_screen.dart';
import 'customer_service_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final dividerColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          '나의 밤톨',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: Icon(Icons.settings_outlined, color: iconColor),
            tooltip: '설정',
          ),
        ],
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, isDark, cardColor),
            Divider(height: 8, thickness: 8, color: dividerColor),
            _buildMenuSection(
              context,
              '나의 거래',
              [
                {
                  'icon': Icons.receipt_long,
                  'title': '판매내역',
                  'screen': const SalesHistoryScreen(),
                },
                {
                  'icon': Icons.shopping_bag_outlined,
                  'title': '구매내역',
                  'screen': const PurchaseHistoryScreen(),
                },
                {
                  'icon': Icons.favorite_border,
                  'title': '관심목록',
                  'screen': const FavoriteProductsScreen(),
                },
              ],
              isDark,
              cardColor,
            ),
            Divider(height: 8, thickness: 8, color: dividerColor),
            _buildMenuSection(
              context,
              '나의 활동',
              [
                {
                  'icon': Icons.article_outlined,
                  'title': '동네생활 글',
                  'screen': const MyNeighborhoodPostsScreen(),
                },
                {
                  'icon': Icons.comment_outlined,
                  'title': '동네생활 댓글',
                  'screen': const MyCommentsScreen(),
                },
                {
                  'icon': Icons.star_border,
                  'title': '받은 매너 평가',
                  'screen': const MannerReviewScreen(),
                },
              ],
              isDark,
              cardColor,
            ),
            Divider(height: 8, thickness: 8, color: dividerColor),
            _buildMenuSection(
              context,
              '기타',
              [
                {
                  'icon': Icons.help_outline,
                  'title': '자주 묻는 질문',
                  'screen': const FaqScreen(),
                },
                {
                  'icon': Icons.headset_mic_outlined,
                  'title': '고객센터',
                  'screen': const CustomerServiceScreen(),
                },
                {
                  'icon': Icons.info_outline,
                  'title': '앱 정보',
                  'action': 'app_info',
                },
              ],
              isDark,
              cardColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    bool isDark,
    Color cardColor,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final avatarBgColor = isDark ? Colors.grey[700] : Colors.grey[200];
    final statDividerColor = isDark ? Colors.grey[700] : Colors.grey[300];

    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) {
        final profile = provider.userProfile;

        return Container(
          padding: const EdgeInsets.all(20),
          color: cardColor,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: avatarBgColor,
                    backgroundImage: profile.profileImageBytes != null
                        ? MemoryImage(profile.profileImageBytes!)
                        : null,
                    child: profile.profileImageBytes == null
                        ? Icon(
                            Icons.person,
                            size: 32,
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.id,
                          style: TextStyle(fontSize: 14, color: subTextColor),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      side: BorderSide(
                        color: isDark ? Colors.grey[600]! : Colors.grey,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('프로필 수정'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildStatItem('거래횟수', '0', isDark)),
                  Container(width: 1, height: 40, color: statDividerColor),
                  Expanded(child: _buildStatItem('매너온도', '36.5°C', isDark)),
                  Container(width: 1, height: 40, color: statDividerColor),
                  Expanded(child: _buildStatItem('재거래율', '0%', isDark)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    final labelColor = isDark ? Colors.grey[400] : Colors.grey[600];
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6F0F),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: labelColor)),
      ],
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> items,
    bool isDark,
    Color cardColor,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    return Container(
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          ...items.map((item) => _buildMenuItem(context, item, isDark)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final iconColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final chevronColor = isDark ? Colors.grey[600] : Colors.grey[400];

    return InkWell(
      onTap: () {
        if (item['screen'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item['screen'] as Widget),
          );
        } else if (item['action'] == 'app_info') {
          _showAppInfoDialog(context);
        } else {
          // action 타입인 경우 스낵바 표시
          Get.snackbar('안내', '${item['title']} 기능을 준비 중입니다');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(item['icon'] as IconData, size: 24, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item['title'] as String,
                style: TextStyle(fontSize: 15, color: textColor),
              ),
            ),
            Icon(Icons.chevron_right, color: chevronColor),
          ],
        ),
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('앱 정보'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('규롯마켓'),
              SizedBox(height: 8),
              Text('버전: 1.0.0'),
              SizedBox(height: 8),
              Text('© 2024 Gyurot Market'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
