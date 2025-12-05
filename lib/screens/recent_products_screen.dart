import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';

class RecentProductsScreen extends StatelessWidget {
  const RecentProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('최근 본 상품'),
        actions: [
          if (recentlyViewedProducts.isNotEmpty)
            TextButton(
              onPressed: () {
                recentlyViewedProducts.clear();
                (context as Element).markNeedsBuild();
              },
              child: const Text('전체삭제', style: TextStyle(color: Colors.grey)),
            ),
        ],
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: recentlyViewedProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: isDark ? Colors.grey[600] : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '최근 본 상품이 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '상품을 둘러보고 마음에 드는 상품을 찾아보세요',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: recentlyViewedProducts.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Color(0xFFE5E5E5)),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(recentlyViewedProducts[index].id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    recentlyViewedProducts.removeAt(index);
                  },
                  child: ProductItem(product: recentlyViewedProducts[index]),
                );
              },
            ),
    );
  }
}
