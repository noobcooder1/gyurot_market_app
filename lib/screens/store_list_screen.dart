import 'package:flutter/material.dart';
import '../data/store_data.dart';
import 'store_detail_screen.dart';

class StoreListScreen extends StatelessWidget {
  final String category;

  const StoreListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[200];

    final categoryStores = getStoresByCategory(category);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: Text(
          category,
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
              ).showSnackBar(SnackBar(content: Text('$category 검색')));
            },
            icon: Icon(Icons.search, color: iconColor),
          ),
        ],
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: categoryStores.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: 64,
                    color: isDark ? Colors.grey[600] : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '등록된 $category이(가) 없습니다',
                    style: TextStyle(fontSize: 16, color: subTextColor),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: categoryStores.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: dividerColor),
              itemBuilder: (context, index) {
                final store = categoryStores[index];
                return _buildStoreItem(
                  context,
                  store,
                  isDark,
                  textColor,
                  subTextColor!,
                  dividerColor!,
                  cardColor,
                );
              },
            ),
    );
  }

  Widget _buildStoreItem(
    BuildContext context,
    Store store,
    bool isDark,
    Color textColor,
    Color subTextColor,
    Color dividerColor,
    Color cardColor,
  ) {
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
        color: cardColor,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: store.imageUrl != null
                    ? Image.network(
                        store.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.store,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                          size: 32,
                        ),
                      )
                    : Icon(
                        Icons.store,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                        size: 32,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 4),
                  Text(
                    store.openingHours,
                    style: TextStyle(fontSize: 12, color: subTextColor),
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
