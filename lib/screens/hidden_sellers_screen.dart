import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/user_preferences.dart';

class HiddenSellersScreen extends StatefulWidget {
  const HiddenSellersScreen({super.key});

  @override
  State<HiddenSellersScreen> createState() => _HiddenSellersScreenState();
}

class _HiddenSellersScreenState extends State<HiddenSellersScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: const Text('숨긴 판매자 관리'),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: hiddenSellerInfoList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.visibility_off_outlined,
                    size: 64,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '숨긴 판매자가 없습니다',
                    style: TextStyle(fontSize: 16, color: subTextColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '상품 상세에서 판매자를 숨기면\n여기에서 관리할 수 있습니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[600] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: hiddenSellerInfoList.length,
              separatorBuilder: (context, index) =>
                  Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
              itemBuilder: (context, index) {
                final seller = hiddenSellerInfoList[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: isDark
                            ? Colors.grey[700]
                            : Colors.grey[200],
                        child: Text(
                          seller.name.substring(0, 1),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              seller.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(seller.hiddenAt),
                              style: TextStyle(
                                fontSize: 13,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showUnhideDialog(context, seller, isDark);
                        },
                        child: const Text(
                          '숨기기 해제',
                          style: TextStyle(color: Color(0xFFFF6F0F)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}에 숨김';
  }

  void _showUnhideDialog(
    BuildContext context,
    HiddenSellerInfo seller,
    bool isDark,
  ) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: Text('숨기기 해제', style: TextStyle(color: textColor)),
          content: Text(
            '${seller.name}님의 숨기기를 해제하시겠습니까?\n\n해제하면 해당 판매자의 게시글이 다시 표시됩니다.',
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  unhideSeller(seller.id);
                });
                Navigator.pop(context);
                Get.snackbar(
                  '완료',
                  '${seller.name}님의 숨기기가 해제되었습니다',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text(
                '해제',
                style: TextStyle(color: Color(0xFFFF6F0F)),
              ),
            ),
          ],
        );
      },
    );
  }
}
