import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 숨김 탭 제거
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    // 내가 직접 등록한 상품만 필터 (현재 로그인된 사용자 ID로 판별)
    final myProducts = productList
        .where((p) => p.userId == currentUserId)
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('판매내역'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
        bottom: TabBar(
          controller: _tabController,
          labelColor: iconColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFF6F0F),
          tabs: const [
            Tab(text: '판매중'),
            Tab(text: '거래완료'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductList(myProducts, '판매 중인 상품이 없습니다', isDark),
          _buildProductList([], '거래 완료된 상품이 없습니다', isDark),
        ],
      ),
    );
  }

  Widget _buildProductList(
    List<Product> products,
    String emptyMessage,
    bool isDark,
  ) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
      itemBuilder: (context, index) {
        return ProductItem(product: products[index]);
      },
    );
  }
}
