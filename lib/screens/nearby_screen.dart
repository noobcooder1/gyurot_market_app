import 'package:flutter/material.dart';
import '../data/store_data.dart';
import 'store_detail_screen.dart';
import 'store_list_screen.dart';
import 'nearby_search_screen.dart';
import 'location_setting_screen.dart';
import 'popular_stores_screen.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  String _currentLocation = '아라동';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NearbySearchScreen(),
                ),
              );
            },
            icon: Icon(Icons.search, color: iconColor),
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
    return InkWell(
      onTap: () async {
        final result = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => const LocationSettingScreen(),
          ),
        );
        if (result != null && mounted) {
          setState(() {
            _currentLocation = result;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: cardColor,
        child: Row(
          children: [
            const Icon(Icons.location_on, size: 20, color: Color(0xFFFF6F0F)),
            const SizedBox(width: 8),
            Text(
              '$_currentLocation 근처',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 20, color: textColor),
          ],
        ),
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
        itemCount: storeCategories.length,
        itemBuilder: (context, index) {
          final category = storeCategories[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StoreListScreen(category: category.name),
                ),
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
                    category.icon,
                    color: const Color(0xFFFF6F0F),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
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
    final popularStores = getPopularStores(
      limit: 5,
      location: _currentLocation,
    );

    return Container(
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '내 근처 인기 가게',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PopularStoresScreen(),
                      ),
                    );
                  },
                  child: const Text('더보기'),
                ),
              ],
            ),
          ),
          ...popularStores.map(
            (store) => _buildStoreItem(context, store, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreItem(BuildContext context, Store store, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey;
    final dividerColor = isDark ? Colors.grey[800] : const Color(0xFFE5E5E5);
    final iconBgColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreDetailScreen(store: store),
          ),
        );
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: store.imageUrl != null
                    ? Image.network(
                        store.imageUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.store, color: subTextColor),
                      )
                    : Icon(Icons.store, color: subTextColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${store.category} · ${store.distance}',
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
                        '${store.rating}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${store.reviewCount})',
                        style: TextStyle(fontSize: 13, color: subTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: subTextColor),
          ],
        ),
      ),
    );
  }
}
