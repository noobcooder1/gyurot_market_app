import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/chat_data.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'chat_detail_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    // 상품의 관심상품 상태로 초기화
    isLiked = widget.product.isFavorite;
  }

  // 같은 카테고리의 추천 상품 가져오기
  List<Product> _getSimilarProducts() {
    final currentCategory = widget.product.category;
    if (currentCategory == null) return [];

    return productList
        .where(
          (p) => p.category == currentCategory && p.id != widget.product.id,
        )
        .take(6)
        .toList();
  }

  // 공유하기 기능
  Future<void> _shareProduct() async {
    final String shareText =
        '''
📦 ${widget.product.title}

💰 ${widget.product.price}
📍 ${widget.product.location}

👤 판매자: ${widget.product.sellerName}

🥕 규롯마켓에서 확인하세요!
''';

    try {
      await Share.share(shareText, subject: widget.product.title);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('공유하기에 실패했습니다.')));
      }
    }
  }

  // 관심상품 토글
  void _toggleFavorite() {
    setState(() {
      isLiked = !isLiked;
      widget.product.isFavorite = isLiked;

      if (isLiked) {
        // 관심상품에 추가
        if (!favoriteProducts.contains(widget.product)) {
          favoriteProducts.add(widget.product);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('관심목록에 추가되었습니다'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        // 관심상품에서 제거
        favoriteProducts.remove(widget.product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('관심목록에서 제거되었습니다'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  // 채팅 시작
  void _startChat() {
    // 내 상품이면 채팅 불가
    if (widget.product.userId == currentUserId) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('내 상품에는 채팅할 수 없습니다.')));
      return;
    }

    // 채팅방 가져오거나 생성
    final chatRoom = getOrCreateChatRoom(widget.product);

    // 채팅 상세 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          chat: {
            'id': chatRoom.id,
            'name': chatRoom.recipientName,
            'product': chatRoom.product.title,
            'productId': chatRoom.product.id,
            'chatRoom': chatRoom,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final similarProducts = _getSimilarProducts();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _shareProduct,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.ios_share,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _showMoreOptions(context);
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.product.title,
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 64),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildProductInfo(isDark, similarProducts)),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(isDark),
    );
  }

  Widget _buildProductInfo(bool isDark, List<Product> similarProducts) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 판매자 정보
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.sellerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      widget.product.location,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.thermostat, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '36.5°C',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 32),

          // 상품 제목
          Text(
            widget.product.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // 카테고리 및 시간
          Text(
            '${widget.product.category ?? '기타'} · ${widget.product.time}',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),

          // 상품 설명
          Text(
            widget.product.description ??
                '상품 상태가 좋습니다.\n직거래 환영합니다.\n가격 네고 가능합니다.',
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // 조회수 및 관심
          Text(
            '관심 ${widget.product.likes + (isLiked ? 1 : 0)} · 조회 124',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),

          const SizedBox(height: 16),

          // 신고하기
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('신고 접수되었습니다')));
            },
            child: Text(
              '이 게시글 신고하기',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ),

          const Divider(height: 32),

          // 비슷한 상품 보기
          if (similarProducts.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '이 카테고리의 다른 상품',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 카테고리 전체 보기
                    Get.snackbar('알림', '${widget.product.category} 카테고리 전체 보기');
                  },
                  child: const Text('더보기'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: similarProducts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _buildSimilarProductItem(
                    isDark,
                    similarProducts[index],
                  );
                },
              ),
            ),
          ] else ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '같은 카테고리의 다른 상품이 없습니다',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ),
            ),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSimilarProductItem(bool isDark, Product product) {
    return GestureDetector(
      onTap: () {
        // 해당 상품 상세페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: 130,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 130,
                    height: 110,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              product.price,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: _toggleFavorite,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 24,
                  color: isLiked
                      ? Colors.red
                      : (isDark ? Colors.white : Colors.black54),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 1,
              height: 40,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const Text(
                    '가격 제안 불가',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _startChat();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F0F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '채팅하기',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    final bool isMyPost = widget.product.userId == currentUserId;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              if (isMyPost) ...[
                // 내 게시글인 경우
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('게시글 수정'),
                  onTap: () {
                    Navigator.pop(context);
                    Get.snackbar('알림', '게시글 수정 화면으로 이동합니다');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('끌어올리기'),
                  onTap: () {
                    Navigator.pop(context);
                    Get.snackbar('완료', '게시글이 끌어올려졌습니다');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.visibility_off_outlined),
                  title: const Text('숨기기'),
                  onTap: () {
                    Navigator.pop(context);
                    Get.snackbar('완료', '게시글이 숨겨졌습니다');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('삭제', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmDialog(context);
                  },
                ),
              ] else ...[
                // 다른 사람 게시글인 경우
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: const Text('공유하기'),
                  onTap: () {
                    Navigator.pop(context);
                    _shareProduct();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.visibility_off_outlined),
                  title: const Text('이 판매자의 글 숨기기'),
                  onTap: () {
                    Navigator.pop(context);
                    Get.snackbar('완료', '이 판매자의 게시글이 숨겨집니다');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined, color: Colors.red),
                  title: const Text(
                    '신고하기',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog(context);
                  },
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showReportDialog(BuildContext context) {
    final reasons = [
      '광고성 콘텐츠예요',
      '거래 금지 물품이에요',
      '사기인 것 같아요',
      '전문 판매업자 같아요',
      '다른 문제가 있어요',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '신고 사유를 선택해주세요',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...reasons.map(
                (reason) => ListTile(
                  title: Text(reason),
                  onTap: () {
                    Navigator.pop(context);
                    Get.snackbar('신고 접수', '신고가 접수되었습니다. 검토 후 조치하겠습니다.');
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('게시글 삭제'),
          content: const Text('이 게시글을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 실제로 productList에서 제거
                productList.removeWhere((p) => p.id == widget.product.id);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('게시글이 삭제되었습니다')));
              },
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
