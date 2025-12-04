import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_item.dart';
import '../widgets/product_grid_item.dart';
import 'search_screen.dart';
import 'menu_screen.dart';
import 'notification_screen.dart';
import 'location_setting_screen.dart';
import 'product_write_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentLocation = '아라동';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 반응형 브레이크포인트 정의
        final bool isMobile = constraints.maxWidth < 600;
        final bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
        final bool isDesktop = constraints.maxWidth >= 1024;

        // 화면 크기에 따른 값 설정
        final double titleFontSize = isMobile ? 16 : (isTablet ? 18 : 20);
        final double iconSize = isMobile ? 24 : (isTablet ? 26 : 28);
        final double horizontalPadding = isMobile ? 0 : (isTablet ? 16 : 24);

        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () async {
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationSettingScreen(),
                  ),
                );
                if (result != null) {
                  setState(() {
                    currentLocation = result;
                  });
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentLocation,
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                  SizedBox(width: isMobile ? 2 : 4),
                  Icon(Icons.expand_more, size: iconSize, color: iconColor),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.search, color: iconColor, size: iconSize),
                tooltip: '검색',
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuScreen()),
                  );
                },
                icon: Icon(Icons.menu, color: iconColor, size: iconSize),
                tooltip: '메뉴',
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: iconColor,
                  size: iconSize,
                ),
                tooltip: '알림',
              ),
              if (!isMobile) const SizedBox(width: 8),
            ],
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            foregroundColor: iconColor,
            elevation: 0.5,
          ),
          body: SizedBox.expand(
            child: _buildResponsiveBody(
              context,
              constraints,
              isMobile,
              isTablet,
              isDesktop,
              horizontalPadding,
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductWriteScreen(),
                ),
              );
            },
            backgroundColor: const Color(0xFFFF6F0F),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              '글쓰기',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveBody(
    BuildContext context,
    BoxConstraints constraints,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    double horizontalPadding,
  ) {
    if (isMobile) {
      // 모바일 뷰: 리스트 형태
      return ListView.separated(
        itemCount: productList.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
        itemBuilder: (context, index) {
          return ProductItem(product: productList[index]);
        },
      );
    } else {
      // 태블릿/데스크톱 뷰: 그리드 형태
      int crossAxisCount;

      if (isTablet) {
        crossAxisCount = (constraints.maxWidth / 250).floor().clamp(2, 3);
      } else {
        crossAxisCount = (constraints.maxWidth / 280).floor().clamp(3, 6);
      }

      final double spacing = isTablet ? 12 : 16;
      final double verticalPadding = isTablet ? 12 : 16;

      return GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.75,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return ProductGridItem(product: productList[index]);
        },
      );
    }
  }
}
