import 'package:flutter/material.dart';
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
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final dividerColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('메뉴'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          // 메뉴 섹션
          _buildSectionHeader('메뉴', isDark),
          Container(
            color: cardColor,
            child: Column(
              children: [
                _buildMenuTile(Icons.edit, '내 물건 팔기', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductWriteScreen(),
                    ),
                  );
                }, isDark),
                _buildDivider(dividerColor),
                _buildMenuTile(Icons.category_outlined, '카테고리', () {
                  Navigator.pop(context);
                  _showCategoryBottomSheet(context);
                }, isDark),
                _buildDivider(dividerColor),
                _buildMenuTile(Icons.history, '최근 본 상품', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecentProductsScreen(),
                    ),
                  );
                }, isDark),
                _buildDivider(dividerColor),
                _buildMenuTile(Icons.favorite_border, '관심목록', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteProductsScreen(),
                    ),
                  );
                }, isDark),
                _buildDivider(dividerColor),
                _buildMenuTile(Icons.settings_outlined, '설정', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                }, isDark),
              ],
            ),
          ),
          Divider(height: 8, thickness: 8, color: dividerColor),

          // 정보 섹션
          _buildSectionHeader('정보', isDark),
          Container(
            color: cardColor,
            child: Column(
              children: [
                _buildMenuTile(Icons.help_outline, '공지사항', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NoticeScreen(),
                    ),
                  );
                }, isDark),
                _buildDivider(dividerColor),
                _buildMenuTile(Icons.info_outline, '앱 정보', () {
                  Navigator.pop(context);
                  _showAppInfoDialog(context);
                }, isDark),
              ],
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

  Widget _buildMenuTile(
    IconData icon,
    String title,
    VoidCallback onTap,
    bool isDark,
  ) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : Colors.black,
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
