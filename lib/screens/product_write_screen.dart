import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/user_profile.dart';

class ProductWriteScreen extends StatefulWidget {
  final Product? editProduct; // 수정할 상품 (null이면 신규 등록)

  const ProductWriteScreen({super.key, this.editProduct});

  @override
  State<ProductWriteScreen> createState() => _ProductWriteScreenState();
}

class _ProductWriteScreenState extends State<ProductWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedLocation;
  bool _isPriceNegotiable = false;
  final List<Uint8List> _images = [];
  final ImagePicker _picker = ImagePicker();

  bool get _isEditMode => widget.editProduct != null;

  final List<String> _categories = [
    '디지털기기',
    '생활가전',
    '가구/인테리어',
    '유아동',
    '생활/가공식품',
    '스포츠/레저',
    '여성잡화',
    '여성의류',
    '남성패션/잡화',
    '게임/취미',
    '뷰티/미용',
    '반려동물용품',
    '도서/티켓/음반',
    '식물',
    '기타 중고물품',
  ];

  @override
  void initState() {
    super.initState();
    // 수정 모드인 경우 기존 데이터로 초기화
    if (widget.editProduct != null) {
      final product = widget.editProduct!;
      _titleController.text = product.title;
      _priceController.text = product.price.replaceAll(RegExp(r'[^0-9]'), '');
      _descriptionController.text = product.description ?? '';
      _selectedCategory = product.category;
      _selectedLocation = product.location;
      _isPriceNegotiable =
          product.price.contains('가격') || product.price == '가격 미정';
      if (product.images != null) {
        _images.addAll(product.images!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[400];
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[300];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: iconColor),
        ),
        title: Text(
          _isEditMode ? '게시글 수정' : '내 물건 팔기',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: _submitProduct,
            child: const Text(
              '완료',
              style: TextStyle(
                color: Color(0xFFFF6F0F),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 선택
            Container(
              color: cardColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // 카메라 버튼
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: dividerColor!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 28,
                                  color: hintColor,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_images.length}/10',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 선택된 이미지들
                        ..._images.asMap().entries.map((entry) {
                          return Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[300],
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    entry.value,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.image),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _images.removeAt(entry.key);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // 제목
            Container(
              color: cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _titleController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: '글 제목',
                  hintStyle: TextStyle(color: hintColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // 카테고리 선택
            Container(
              color: cardColor,
              child: ListTile(
                title: Text(
                  _selectedCategory ?? '카테고리 선택',
                  style: TextStyle(
                    color: _selectedCategory != null ? textColor : hintColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: hintColor),
                onTap: () => _showCategoryPicker(context, isDark),
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // 가격
            Container(
              color: cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('₩', style: TextStyle(fontSize: 18, color: textColor)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: '가격 (선택사항)',
                        hintStyle: TextStyle(color: hintColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPriceNegotiable = !_isPriceNegotiable;
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _isPriceNegotiable
                            ? const Color(0xFFFF6F0F)
                            : Colors.transparent,
                        border: Border.all(
                          color: _isPriceNegotiable
                              ? const Color(0xFFFF6F0F)
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _isPriceNegotiable
                          ? const Icon(
                              Icons.check,
                              size: 18,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('가격 제안 받기', style: TextStyle(color: textColor)),
                ],
              ),
            ),
            Divider(height: 1, color: dividerColor),

            // 설명
            Container(
              color: cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _descriptionController,
                maxLines: 8,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText:
                      '게시글 내용을 작성해 주세요. (판매 금지 물품은 게시가 제한될 수 있어요.)\n\n신뢰할 수 있는 거래를 위해 자세히 적어주세요.',
                  hintStyle: TextStyle(color: hintColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            Divider(height: 8, thickness: 8, color: dividerColor),

            // 거래 희망 장소
            Container(
              color: cardColor,
              child: ListTile(
                leading: Icon(Icons.location_on_outlined, color: iconColor),
                title: Text(
                  _selectedLocation ?? '거래 희망 장소',
                  style: TextStyle(
                    color: _selectedLocation != null ? textColor : hintColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: hintColor),
                onTap: () => _showLocationPicker(context, isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (_images.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지는 최대 10장까지 추가할 수 있습니다.')),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _images.add(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('이미지를 불러오는 중 오류가 발생했습니다: $e')));
      }
    }
  }

  void _showCategoryPicker(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
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
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '카테고리 선택',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      return ListTile(
                        title: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFFFF6F0F)
                                : textColor,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Color(0xFFFF6F0F))
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                          Navigator.pop(context);
                        },
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

  void _showLocationPicker(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[400];
    final customLocationController = TextEditingController();

    // 미리 정의된 거래 장소 목록
    final locations = [
      '아라동 주민센터 앞',
      '아라초등학교 정문',
      '이마트 아라점',
      'GS25 아라점',
      'CU 아라동점',
      '아라공원 입구',
      '아라동 우체국',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
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
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '거래 희망 장소',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  // 직접 입력
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: customLocationController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: '장소를 직접 입력하세요',
                        hintStyle: TextStyle(color: hintColor),
                        prefixIcon: Icon(
                          Icons.edit_location_outlined,
                          color: hintColor,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Color(0xFFFF6F0F),
                          ),
                          onPressed: () {
                            if (customLocationController.text.isNotEmpty) {
                              setState(() {
                                _selectedLocation =
                                    customLocationController.text;
                              });
                              Navigator.pop(context);
                            }
                          },
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _selectedLocation = value;
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '추천 장소',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: locations.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        final isSelected = location == _selectedLocation;
                        return ListTile(
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: isSelected
                                ? const Color(0xFFFF6F0F)
                                : Colors.grey[600],
                          ),
                          title: Text(
                            location,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFFFF6F0F)
                                  : textColor,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xFFFF6F0F),
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedLocation = location;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _submitProduct() {
    // 유효성 검사
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('제목을 입력해주세요.')));
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('카테고리를 선택해주세요.')));
      return;
    }
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('내용을 입력해주세요.')));
      return;
    }

    // 가격 포맷팅
    String formattedPrice;
    if (_priceController.text.isEmpty) {
      formattedPrice = '가격 미정';
    } else {
      final priceValue = int.tryParse(
        _priceController.text.replaceAll(',', ''),
      );
      if (priceValue != null) {
        // 천단위 콤마 추가
        formattedPrice = '${_formatNumber(priceValue)}원';
      } else {
        formattedPrice = '${_priceController.text}원';
      }
    }

    // UserProfileProvider에서 프로필 정보 가져오기
    final userProfile = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    ).userProfile;

    if (_isEditMode) {
      // 수정 모드: 기존 상품 업데이트
      final index = productList.indexWhere(
        (p) => p.id == widget.editProduct!.id,
      );
      if (index != -1) {
        productList[index] = Product(
          id: widget.editProduct!.id,
          userId: widget.editProduct!.userId,
          sellerName: widget.editProduct!.sellerName,
          title: _titleController.text,
          location: _selectedLocation ?? widget.editProduct!.location,
          price: formattedPrice,
          imageUrl: widget.editProduct!.imageUrl,
          time: widget.editProduct!.time,
          likes: widget.editProduct!.likes,
          category: _selectedCategory,
          description: _descriptionController.text,
          images: _images.isNotEmpty
              ? List<Uint8List>.from(_images)
              : widget.editProduct!.images,
          imageUrls: widget.editProduct!.imageUrls,
          sellerProfileImage: widget.editProduct!.sellerProfileImage,
          isFavorite: widget.editProduct!.isFavorite,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('게시글이 수정되었습니다!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // 신규 등록 모드
      final newId = 'prod_${DateTime.now().millisecondsSinceEpoch}';
      final newProduct = Product(
        id: newId,
        userId: currentUserId,
        sellerName: userProfile.name,
        title: _titleController.text,
        location: _selectedLocation ?? '아라동',
        price: formattedPrice,
        imageUrl: _images.isNotEmpty
            ? 'https://picsum.photos/200?random=${DateTime.now().millisecondsSinceEpoch}'
            : 'https://picsum.photos/200',
        time: '방금 전',
        likes: 0,
        category: _selectedCategory,
        description: _descriptionController.text,
        images: _images.isNotEmpty ? List<Uint8List>.from(_images) : null,
        sellerProfileImage: userProfile.profileImageBytes,
      );
      productList.insert(0, newProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('상품이 등록되었습니다!'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    // 결과를 true로 반환하여 홈 화면이 새로고침되도록 함
    Navigator.pop(context, true);
  }

  // 숫자 천단위 포맷팅
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
