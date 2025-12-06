import 'package:flutter/material.dart';
import '../data/neighborhood_data.dart';

class NeighborhoodSearchScreen extends StatefulWidget {
  const NeighborhoodSearchScreen({super.key});

  @override
  State<NeighborhoodSearchScreen> createState() =>
      _NeighborhoodSearchScreenState();
}

class _NeighborhoodSearchScreenState extends State<NeighborhoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _recentSearches = ['맛집', '러닝', '축제', '강아지'];
  final List<String> _popularSearches = [
    '동네 맛집',
    '러닝 모임',
    '주말 행사',
    '분실물',
    '취미 생활',
  ];
  List<NeighborhoodPost> _searchResults = [];
  bool _isSearching = false;

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

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = neighborhoodPosts.where((post) {
        return post.title.toLowerCase().contains(query.toLowerCase()) ||
            post.content.toLowerCase().contains(query.toLowerCase()) ||
            post.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });

    // 최근 검색어에 추가
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.take(10).toList();
      }
    }
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  void _removeRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[400];
    final chipBgColor = isDark ? Colors.grey[800] : Colors.grey[200];
    final dividerColor = isDark ? Colors.grey[800] : const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: '동네생활 글 검색',
            hintStyle: TextStyle(color: hintColor),
            border: InputBorder.none,
          ),
          onSubmitted: _performSearch,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                _isSearching = false;
                _searchResults = [];
              });
            }
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: iconColor),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _isSearching = false;
                  _searchResults = [];
                });
              },
            ),
        ],
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: _isSearching
          ? _buildSearchResults(
              isDark,
              textColor,
              subTextColor!,
              cardColor,
              dividerColor!,
            )
          : _buildSearchSuggestions(
              isDark,
              textColor,
              subTextColor!,
              chipBgColor!,
              dividerColor!,
            ),
    );
  }

  Widget _buildSearchSuggestions(
    bool isDark,
    Color textColor,
    Color subTextColor,
    Color chipBgColor,
    Color dividerColor,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 최근 검색어
          if (_recentSearches.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
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
                  GestureDetector(
                    onTap: _clearRecentSearches,
                    child: Text(
                      '전체삭제',
                      style: TextStyle(fontSize: 14, color: subTextColor),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recentSearches.map((search) {
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = search;
                      _performSearch(search);
                    },
                    child: Chip(
                      label: Text(search),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removeRecentSearch(search),
                      backgroundColor: chipBgColor,
                      labelStyle: TextStyle(color: textColor),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Divider(height: 16, thickness: 8, color: dividerColor),
          ],

          // 인기 검색어
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '인기 검색어',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          ...List.generate(_popularSearches.length, (index) {
            return ListTile(
              leading: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: index < 3 ? const Color(0xFFFF6F0F) : subTextColor,
                ),
              ),
              title: Text(
                _popularSearches[index],
                style: TextStyle(color: textColor),
              ),
              onTap: () {
                _searchController.text = _popularSearches[index];
                _performSearch(_popularSearches[index]);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
    bool isDark,
    Color textColor,
    Color subTextColor,
    Color cardColor,
    Color dividerColor,
  ) {
    if (_searchResults.isEmpty) {
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
              '다른 검색어로 검색해보세요',
              style: TextStyle(fontSize: 14, color: subTextColor),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: dividerColor),
      itemBuilder: (context, index) {
        final post = _searchResults[index];
        return ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  post.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              post.content,
              style: TextStyle(fontSize: 13, color: subTextColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onTap: () {
            Navigator.pop(context, post);
          },
        );
      },
    );
  }
}
