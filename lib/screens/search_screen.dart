import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_item.dart';
import '../data/repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _searchResults = productList
          .where(
            (product) =>
                product.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;

    FocusScope.of(context).unfocus(); // Dismiss keyboard
    _searchProducts(query);

    final repository = Repository();
    setState(() {
      if (!repository.recentSearches.contains(query)) {
        repository.recentSearches.insert(0, query);
      } else {
        // Move to top if already exists
        repository.recentSearches.remove(query);
        repository.recentSearches.insert(0, query);
      }
    });
  }

  void _removeRecentSearch(String query) {
    setState(() {
      Repository().recentSearches.remove(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _searchProducts,
          onSubmitted: _handleSearch,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: '검색어를 입력해주세요.',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _handleSearch(_searchController.text),
            ),
          ),
          autofocus: true,
        ),
      ),
      body: _searchController.text.isEmpty
          ? ListView(
              children: [
                const ListTile(title: Text('최근 검색어')),
                ...Repository().recentSearches.map(
                  (search) => ListTile(
                    title: Text(search),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _removeRecentSearch(search),
                    ),
                    onTap: () {
                      _searchController.text = search;
                      _handleSearch(search);
                    },
                  ),
                ),
              ],
            )
          : _searchResults.isEmpty
          ? const Center(child: Text('검색 결과가 없습니다.'))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ProductItem(product: _searchResults[index]);
              },
            ),
    );
  }
}
