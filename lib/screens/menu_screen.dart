import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../src/common/theme_controller.dart';
import 'product_write_screen.dart';
import 'recent_products_screen.dart';
import 'favorite_products_screen.dart';
import 'settings_screen.dart';
import 'notice_screen.dart';
import 'category_products_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('메뉴'),
      ),
      body: ListView(
        children: [
          // 다크모드 토글
          Obx(
            () => _buildMenuItem(
              context: context,
              icon: themeController.isDarkMode.value
                  ? Icons.light_mode
                  : Icons.dark_mode,
              title: '다크모드',
              trailing: Switch(
                value: themeController.isDarkMode.value,
                onChanged: (value) => themeController.setDarkMode(value),
                activeColor: const Color(0xFFFF6F0F),
              ),
              onTap: () => themeController.toggleTheme(),
            ),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context: context,
            icon: Icons.edit,
            title: '내 물건 팔기',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductWriteScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context: context,
            icon: Icons.category_outlined,
            title: '카테고리',
            onTap: () {
              Navigator.pop(context);
              _showCategoryBottomSheet(context);
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context: context,
            icon: Icons.history,
            title: '최근 본 상품',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecentProductsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context: context,
            icon: Icons.favorite_border,
            title: '관심목록',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteProductsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context: context,
            icon: Icons.settings_outlined,
            title: '설정',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(height: 8, thickness: 8, color: Color(0xFFF5F5F5)),
          _buildMenuItem(
            context: context,
            icon: Icons.help_outline,
            title: '공지사항',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NoticeScreen()),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context: context,
            icon: Icons.info_outline,
            title: '앱 정보',
            onTap: () {
              Navigator.pop(context);
              _showAppInfoDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
      onTap: onTap,
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    final categories = [
      {'icon': Icons.devices, 'name': '디지털기기'},
      {'icon': Icons.chair, 'name': '가구/인테리어'},
      {'icon': Icons.child_care, 'name': '유아동'},
      {'icon': Icons.checkroom, 'name': '여성의류'},
      {'icon': Icons.man, 'name': '남성의류'},
      {'icon': Icons.face_retouching_natural, 'name': '뷰티/미용'},
      {'icon': Icons.sports_basketball, 'name': '스포츠/레저'},
      {'icon': Icons.games, 'name': '취미/게임'},
      {'icon': Icons.book, 'name': '도서'},
      {'icon': Icons.pets, 'name': '반려동물용품'},
      {'icon': Icons.kitchen, 'name': '생활/가공식품'},
      {'icon': Icons.more_horiz, 'name': '기타 중고물품'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '카테고리',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryProductsScreen(
                                category: categories[index]['name'] as String,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                categories[index]['icon'] as IconData,
                                color: const Color(0xFFFF6F0F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categories[index]['name'] as String,
                              style: const TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
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
