import 'package:flutter/material.dart';
import '../data/store_data.dart';
import 'store_detail_screen.dart';

class PopularStoresScreen extends StatelessWidget {
  const PopularStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[200];

    final popularStores = getAllPopularStores();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: Text(
          '내 근처 인기 가게',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: ListView.separated(
        itemCount: popularStores.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: dividerColor),
        itemBuilder: (context, index) {
          final store = popularStores[index];
          return _buildStoreItem(
            context,
            store,
            isDark,
            textColor,
            subTextColor!,
            cardColor,
            index + 1,
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
    Color cardColor,
    int rank,
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
            // 순위 표시
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: rank <= 3
                    ? const Color(0xFFFF6F0F)
                    : (isDark ? Colors.grey[700] : Colors.grey[300]),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: rank <= 3 ? Colors.white : textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 가게 이미지
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
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
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.store,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                          size: 28,
                        ),
                      )
                    : Icon(
                        Icons.store,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                        size: 28,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // 가게 정보
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
