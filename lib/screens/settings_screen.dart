import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../src/common/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationEnabled = true;
  bool _chatNotificationEnabled = true;
  bool _keywordNotificationEnabled = true;
  bool _marketingEnabled = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final dividerColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF5F5F5);
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('설정'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          // 알림 설정
          _buildSectionHeader('알림 설정', isDark),
          Container(
            color: cardColor,
            child: Column(
              children: [
                _buildSwitchTile(
                  '전체 알림',
                  '앱 푸시 알림을 받습니다',
                  _notificationEnabled,
                  (value) => setState(() => _notificationEnabled = value),
                  isDark,
                ),
                _buildDivider(dividerColor),
                _buildSwitchTile(
                  '채팅 알림',
                  '새로운 채팅 메시지를 받으면 알림',
                  _chatNotificationEnabled,
                  (value) => setState(() => _chatNotificationEnabled = value),
                  isDark,
                ),
                _buildDivider(dividerColor),
                _buildSwitchTile(
                  '키워드 알림',
                  '등록한 키워드의 새 상품이 올라오면 알림',
                  _keywordNotificationEnabled,
                  (value) =>
                      setState(() => _keywordNotificationEnabled = value),
                  isDark,
                ),
                _buildDivider(dividerColor),
                _buildSwitchTile(
                  '마케팅 알림',
                  '이벤트 및 혜택 정보를 받습니다',
                  _marketingEnabled,
                  (value) => setState(() => _marketingEnabled = value),
                  isDark,
                ),
              ],
            ),
          ),
          Divider(height: 8, thickness: 8, color: dividerColor),

          // 화면 설정
          _buildSectionHeader('화면 설정', isDark),
          Container(
            color: cardColor,
            child: Obx(
              () => _buildSwitchTile(
                '다크 모드',
                '어두운 화면 테마를 사용합니다',
                themeController.isDarkMode.value,
                (value) => themeController.setDarkMode(value),
                isDark,
              ),
            ),
          ),
          Divider(height: 8, thickness: 8, color: dividerColor),

          // 계정 설정
          _buildSectionHeader('계정', isDark),
          Container(
            color: cardColor,
            child: Column(
              children: [
                _buildMenuTile(Icons.location_on_outlined, '내 동네 설정', () {
                  Get.snackbar('안내', '동네 설정 화면으로 이동합니다');
                }, isDark),
                _buildDivider(dividerColor),
                _buildMenuTile(Icons.lock_outline, '개인정보 처리방침', () {
                  Get.snackbar('안내', '개인정보 처리방침을 확인합니다');
                }, isDark),
                _buildDivider(dividerColor),
                _buildMenuTile(Icons.description_outlined, '이용약관', () {
                  Get.snackbar('안내', '이용약관을 확인합니다');
                }, isDark),
              ],
            ),
          ),
          Divider(height: 8, thickness: 8, color: dividerColor),

          // 기타
          Container(
            color: cardColor,
            child: Column(
              children: [
                _buildMenuTile(
                  Icons.logout,
                  '로그아웃',
                  () => _showLogoutDialog(context),
                  isDark,
                  textColor: Colors.red,
                ),
                _buildDivider(dividerColor),
                _buildMenuTile(
                  Icons.delete_forever_outlined,
                  '회원탈퇴',
                  () => _showWithdrawDialog(context),
                  isDark,
                  textColor: Colors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '앱 버전 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    bool isDark,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFFF6F0F),
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title,
    VoidCallback onTap,
    bool isDark, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? (isDark ? Colors.white70 : Colors.black54),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: textColor ?? (isDark ? Colors.white : Colors.black),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDark ? Colors.grey[600] : Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(height: 1, indent: 16, endIndent: 16, color: color);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.offAllNamed('/start');
              Get.snackbar('안내', '로그아웃 되었습니다');
            },
            child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('회원탈퇴'),
        content: const Text('정말 탈퇴하시겠습니까?\n모든 데이터가 삭제되며 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.offAllNamed('/start');
              Get.snackbar('안내', '회원탈퇴가 완료되었습니다');
            },
            child: const Text('탈퇴', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
