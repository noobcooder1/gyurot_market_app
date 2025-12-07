import 'package:flutter/material.dart';
import '../data/store_data.dart';
import 'store_detail_screen.dart';

class NearbySearchScreen extends StatefulWidget {
  const NearbySearchScreen({super.key});

  @override
  State<NearbySearchScreen> createState() => _NearbySearchScreenState();
}

class _NearbySearchScreenState extends State<NearbySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> recentSearches = ['카페', '맛집', '약국', '편의점'];
  List<String> popularSearches = ['분식', '순대국', '헬스장', '미용실', '병원'];
  List<Store> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
    } else {
      _searchStores(query);
    }
  }

  // 가게 검색
  void _searchStores(String query) {
    final lowerQuery = query.toLowerCase();
    final results = stores.where((store) {
      return store.name.toLowerCase().contains(lowerQuery) ||
          store.category.toLowerCase().contains(lowerQuery) ||
          store.description.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      searchResults = results;
      isSearching = true;
    });
  }

  // 검색 실행
  void _performSearch(String query) {
    if (query.isEmpty) return;

    // 검색어 입력
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );

    // 최근 검색어에 추가
    setState(() {
      recentSearches.remove(query);
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
    });

    // 검색 실행
    _searchStores(query);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '가게, 카테고리 검색',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          style: TextStyle(color: iconColor),
          onSubmitted: (value) => _performSearch(value),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  searchResults = [];
                  isSearching = false;
                });
              },
              icon: Icon(Icons.close, color: iconColor, size: 20),
            ),
        ],
      ),
      body: isSearching
          ? _buildSearchResults(isDark, cardColor)
          : _buildSearchSuggestions(isDark, iconColor, cardColor),
    );
  }

  // 검색 결과 표시
  Widget _buildSearchResults(bool isDark, Color cardColor) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[200];

    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다',
              style: TextStyle(fontSize: 16, color: subTextColor),
            ),
            const SizedBox(height: 8),
            Text(
              '다른 검색어로 시도해보세요',
              style: TextStyle(fontSize: 14, color: subTextColor),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: searchResults.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: dividerColor),
      itemBuilder: (context, index) {
        final store = searchResults[index];
        return _buildStoreItem(
          store,
          isDark,
          textColor,
          subTextColor!,
          cardColor,
        );
      },
    );
  }

  // 가게 아이템
  Widget _buildStoreItem(
    Store store,
    bool isDark,
    Color textColor,
    Color subTextColor,
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
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.store,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
                size: 28,
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

  // 검색 제안 (최근 검색어 + 인기 검색어)
  Widget _buildSearchSuggestions(
    bool isDark,
    Color iconColor,
    Color cardColor,
  ) {
    final dividerColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF5F5F5);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentSearches(isDark, iconColor, cardColor),
          Divider(height: 8, thickness: 8, color: dividerColor),
          _buildPopularSearches(isDark, cardColor),
        ],
      ),
    );
  }

  // 최근 검색어
  Widget _buildRecentSearches(bool isDark, Color iconColor, Color cardColor) {
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      color: cardColor,
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
                  color: textColor,
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
                return GestureDetector(
                  onTap: () => _performSearch(search),
                  child: Chip(
                    label: Text(search),
                    deleteIcon: Icon(Icons.close, size: 16, color: iconColor),
                    onDeleted: () {
                      setState(() {
                        recentSearches.remove(search);
                      });
                    },
                    backgroundColor: isDark
                        ? Colors.grey[800]
                        : Colors.grey[100],
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // 인기 검색어
  Widget _buildPopularSearches(bool isDark, Color cardColor) {
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      color: cardColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '인기 카테고리',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...popularSearches.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final search = entry.value;
            return InkWell(
              onTap: () => _performSearch(search),
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
