import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NearbyScreen extends StatelessWidget {
  const NearbyScreen({super.key});

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
          '내 근처',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('검색 기능')));
            },
            icon: SvgPicture.asset(
              'assets/svg/icons/search.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            tooltip: '검색',
          ),
        ],
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationHeader(context, isDark, cardColor),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[800] : Colors.grey[300],
            ),
            _buildCategoryGrid(context, isDark, cardColor),
            Divider(height: 8, thickness: 8, color: dividerColor),
            _buildNearbyStores(context, isDark, cardColor),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationHeader(
    BuildContext context,
    bool isDark,
    Color cardColor,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    return Container(
      padding: const EdgeInsets.all(16),
      color: cardColor,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/icons/want_location_marker.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Color(0xFFFF6F0F),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '아라동 근처',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          Icon(Icons.keyboard_arrow_down, size: 20, color: textColor),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(
    BuildContext context,
    bool isDark,
    Color cardColor,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final iconBgColor = isDark ? Colors.grey[800] : Colors.grey[100];
    final categories = [
      {'icon': Icons.restaurant, 'name': '맛집'},
      {'icon': Icons.local_cafe, 'name': '카페'},
      {'icon': Icons.storefront, 'name': '편의점'},
      {'icon': Icons.local_pharmacy, 'name': '약국'},
      {'icon': Icons.local_hospital, 'name': '병원'},
      {'icon': Icons.fitness_center, 'name': '헬스장'},
      {'icon': Icons.school, 'name': '학원'},
      {'icon': Icons.more_horiz, 'name': '더보기'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      color: cardColor,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${categories[index]['name']} 카테고리')),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    categories[index]['icon'] as IconData,
                    color: const Color(0xFFFF6F0F),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index]['name'] as String,
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyStores(
    BuildContext context,
    bool isDark,
    Color cardColor,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final stores = [
      {
        'name': '맛있는 분식집',
        'category': '분식',
        'distance': '350m',
        'rating': 4.8,
        'reviews': 128,
      },
      {
        'name': '동네 카페',
        'category': '카페',
        'distance': '500m',
        'rating': 4.5,
        'reviews': 89,
      },
      {
        'name': '건강 약국',
        'category': '약국',
        'distance': '200m',
        'rating': 4.9,
        'reviews': 256,
      },
    ];

    return Container(
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '내 근처 인기 가게',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          ...stores.map((store) => _buildStoreItem(context, store, isDark)),
        ],
      ),
    );
  }

  Widget _buildStoreItem(
    BuildContext context,
    Map<String, dynamic> store,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey;
    final dividerColor = isDark ? Colors.grey[800] : const Color(0xFFE5E5E5);
    final iconBgColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${store['name']} 상세 페이지')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: dividerColor!)),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.store, color: subTextColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${store['category']} · ${store['distance']}',
                    style: TextStyle(fontSize: 13, color: subTextColor),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Color(0xFFFFB800),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${store['rating']}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${store['reviews']})',
                        style: TextStyle(fontSize: 13, color: subTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
