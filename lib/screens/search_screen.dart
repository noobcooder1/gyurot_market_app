import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> recentSearches = ['아이폰', '자전거', '책상', '에어팟'];
  List<String> popularSearches = ['아이폰 15', '맥북', '닌텐도 스위치', '에어팟 프로', '갤럭시'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            'assets/svg/icons/back.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '검색어를 입력하세요',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                if (!recentSearches.contains(value)) {
                  recentSearches.insert(0, value);
                  if (recentSearches.length > 10) {
                    recentSearches.removeLast();
                  }
                }
              });
              // TODO: 검색 결과 화면으로 이동
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('"$value" 검색 결과')));
            }
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              icon: SvgPicture.asset(
                'assets/svg/icons/close.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecentSearches(isDark, iconColor),
            const Divider(height: 8, thickness: 8, color: Color(0xFFF5F5F5)),
            _buildPopularSearches(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches(bool isDark, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 검색어',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    recentSearches.clear();
                  });
                },
                child: const Text('전체삭제', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (recentSearches.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  '최근 검색어가 없습니다',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((search) {
                return Chip(
                  label: Text(search),
                  deleteIcon: Icon(Icons.close, size: 16, color: iconColor),
                  onDeleted: () {
                    setState(() {
                      recentSearches.remove(search);
                    });
                  },
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPopularSearches(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '인기 검색어',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...popularSearches.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final search = entry.value;
            return InkWell(
              onTap: () {
                _searchController.text = search;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('"$search" 검색 결과')));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '$index',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: index <= 3
                              ? const Color(0xFFFF6F0F)
                              : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      search,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
