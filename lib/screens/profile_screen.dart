import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import 'menu_screen.dart';

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
                MaterialPageRoute(builder: (context) => const MenuScreen()),
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
                {'icon': Icons.receipt_long, 'title': '판매내역'},
                {'icon': Icons.shopping_bag_outlined, 'title': '구매내역'},
                {'icon': Icons.favorite_border, 'title': '관심목록'},
              ],
              isDark,
              cardColor,
            ),
            Divider(height: 8, thickness: 8, color: dividerColor),
            _buildMenuSection(
              context,
              '나의 활동',
              [
                {'icon': Icons.article_outlined, 'title': '동네생활 글'},
                {'icon': Icons.comment_outlined, 'title': '동네생활 댓글'},
                {'icon': Icons.star_border, 'title': '받은 매너 평가'},
              ],
              isDark,
              cardColor,
            ),
            Divider(height: 8, thickness: 8, color: dividerColor),
            _buildMenuSection(
              context,
              '기타',
              [
                {'icon': Icons.help_outline, 'title': '자주 묻는 질문'},
                {'icon': Icons.headset_mic_outlined, 'title': '고객센터'},
                {'icon': Icons.info_outline, 'title': '앱 정보'},
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
                    backgroundImage: profile.profileImage != null
                        ? AssetImage(profile.profileImage!)
                        : const AssetImage('assets/images/default_profile.png'),
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
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('프로필 수정')));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${item['title']}')));
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
}
