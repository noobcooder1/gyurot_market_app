import 'package:flutter/material.dart';

/// 가게 데이터 모델
class Store {
  final String id;
  final String name;
  final String category;
  final String description;
  final String address;
  final String distance;
  final double rating;
  final int reviewCount;
  final String phoneNumber;
  final String openingHours;
  final List<String> images;
  final List<MenuItem> menu;
  final List<Review> reviews;

  Store({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.phoneNumber,
    required this.openingHours,
    this.images = const [],
    this.menu = const [],
    this.reviews = const [],
  });
}

/// 메뉴 아이템
class MenuItem {
  final String name;
  final String price;
  final String? description;

  MenuItem({required this.name, required this.price, this.description});
}

/// 리뷰
class Review {
  final String authorName;
  final double rating;
  final String content;
  final DateTime createdAt;

  Review({
    required this.authorName,
    required this.rating,
    required this.content,
    required this.createdAt,
  });

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}달 전';
    if (diff.inDays > 0) return '${diff.inDays}일 전';
    return '오늘';
  }
}

/// 카테고리 정보
class StoreCategory {
  final IconData icon;
  final String name;
  final String description;

  StoreCategory({
    required this.icon,
    required this.name,
    required this.description,
  });
}

/// 전역 카테고리 리스트
final List<StoreCategory> storeCategories = [
  StoreCategory(icon: Icons.restaurant, name: '맛집', description: '동네 인기 맛집'),
  StoreCategory(icon: Icons.local_cafe, name: '카페', description: '분위기 좋은 카페'),
  StoreCategory(icon: Icons.storefront, name: '편의점', description: '24시간 편의점'),
  StoreCategory(icon: Icons.local_pharmacy, name: '약국', description: '가까운 약국'),
  StoreCategory(icon: Icons.local_hospital, name: '병원', description: '동네 병원'),
  StoreCategory(icon: Icons.fitness_center, name: '헬스장', description: '운동 시설'),
  StoreCategory(icon: Icons.school, name: '학원', description: '교육 기관'),
  StoreCategory(icon: Icons.spa, name: '미용실', description: '헤어샵/네일샵'),
];

/// 전역 가게 리스트
List<Store> stores = [
  // 맛집
  Store(
    id: 'store_001',
    name: '맛있는 분식집',
    category: '맛집',
    description: '정성껏 만든 분식을 선보이는 동네 맛집입니다.',
    address: '아라동 123-45',
    distance: '350m',
    rating: 4.8,
    reviewCount: 128,
    phoneNumber: '010-1234-5678',
    openingHours: '10:00 - 22:00',
    menu: [
      MenuItem(name: '떡볶이', price: '4,000원', description: '매콤달콤'),
      MenuItem(name: '순대', price: '4,000원'),
      MenuItem(name: '튀김모듬', price: '5,000원'),
      MenuItem(name: '라볶이', price: '5,500원'),
    ],
    reviews: [
      Review(
        authorName: '맛집탐방',
        rating: 5.0,
        content: '떡볶이 진짜 맛있어요!',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Review(
        authorName: '순대러버',
        rating: 4.5,
        content: '순대도 추천합니다',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ],
  ),
  Store(
    id: 'store_002',
    name: '할매순대국',
    category: '맛집',
    description: '40년 전통 순대국 전문점',
    address: '아라동 456-78',
    distance: '500m',
    rating: 4.7,
    reviewCount: 256,
    phoneNumber: '010-2345-6789',
    openingHours: '06:00 - 21:00',
    menu: [
      MenuItem(name: '순대국', price: '8,000원'),
      MenuItem(name: '내장탕', price: '9,000원'),
      MenuItem(name: '모듬수육', price: '25,000원'),
    ],
    reviews: [
      Review(
        authorName: '국밥매니아',
        rating: 5.0,
        content: '역시 전통의 맛!',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ],
  ),
  Store(
    id: 'store_003',
    name: '청년피자',
    category: '맛집',
    description: '화덕에서 구운 수제 피자',
    address: '아라동 789-12',
    distance: '800m',
    rating: 4.6,
    reviewCount: 89,
    phoneNumber: '010-3456-7890',
    openingHours: '11:00 - 22:00',
  ),

  // 카페
  Store(
    id: 'store_004',
    name: '동네 카페',
    category: '카페',
    description: '조용하고 아늑한 동네 카페',
    address: '아라동 234-56',
    distance: '400m',
    rating: 4.5,
    reviewCount: 89,
    phoneNumber: '010-4567-8901',
    openingHours: '09:00 - 22:00',
    menu: [
      MenuItem(name: '아메리카노', price: '4,500원'),
      MenuItem(name: '카페라떼', price: '5,000원'),
      MenuItem(name: '티라미수', price: '6,500원'),
    ],
  ),
  Store(
    id: 'store_005',
    name: '스터디카페 집중',
    category: '카페',
    description: '조용한 분위기의 스터디 카페',
    address: '아라동 567-89',
    distance: '600m',
    rating: 4.3,
    reviewCount: 45,
    phoneNumber: '010-5678-9012',
    openingHours: '24시간',
  ),

  // 약국
  Store(
    id: 'store_006',
    name: '건강 약국',
    category: '약국',
    description: '친절한 상담과 빠른 조제',
    address: '아라동 111-22',
    distance: '200m',
    rating: 4.9,
    reviewCount: 256,
    phoneNumber: '010-6789-0123',
    openingHours: '09:00 - 21:00',
  ),
  Store(
    id: 'store_007',
    name: '24시 올나이트약국',
    category: '약국',
    description: '24시간 운영 약국',
    address: '아라동 333-44',
    distance: '450m',
    rating: 4.7,
    reviewCount: 178,
    phoneNumber: '010-7890-1234',
    openingHours: '24시간',
  ),

  // 편의점
  Store(
    id: 'store_008',
    name: 'CU 아라점',
    category: '편의점',
    description: '24시간 편의점',
    address: '아라동 222-33',
    distance: '100m',
    rating: 4.2,
    reviewCount: 34,
    phoneNumber: '010-8901-2345',
    openingHours: '24시간',
  ),
  Store(
    id: 'store_009',
    name: 'GS25 아라중앙점',
    category: '편의점',
    description: '24시간 편의점',
    address: '아라동 444-55',
    distance: '250m',
    rating: 4.1,
    reviewCount: 28,
    phoneNumber: '010-9012-3456',
    openingHours: '24시간',
  ),

  // 병원
  Store(
    id: 'store_010',
    name: '아라내과의원',
    category: '병원',
    description: '내과 전문 의원',
    address: '아라동 555-66',
    distance: '300m',
    rating: 4.6,
    reviewCount: 156,
    phoneNumber: '010-0123-4567',
    openingHours: '09:00 - 18:00',
  ),

  // 헬스장
  Store(
    id: 'store_011',
    name: '파워짐 휘트니스',
    category: '헬스장',
    description: '최신 장비 완비 헬스장',
    address: '아라동 666-77',
    distance: '550m',
    rating: 4.4,
    reviewCount: 87,
    phoneNumber: '010-1234-5678',
    openingHours: '06:00 - 24:00',
  ),

  // 학원
  Store(
    id: 'store_012',
    name: '영어마을어학원',
    category: '학원',
    description: '영어 전문 학원',
    address: '아라동 777-88',
    distance: '700m',
    rating: 4.5,
    reviewCount: 67,
    phoneNumber: '010-2345-6789',
    openingHours: '14:00 - 22:00',
  ),

  // 미용실
  Store(
    id: 'store_013',
    name: '헤어살롱 뷰티',
    category: '미용실',
    description: '스타일 전문 헤어샵',
    address: '아라동 888-99',
    distance: '400m',
    rating: 4.7,
    reviewCount: 134,
    phoneNumber: '010-3456-7890',
    openingHours: '10:00 - 20:00',
  ),
];

/// 카테고리별 가게 필터링
List<Store> getStoresByCategory(String category) {
  return stores.where((store) => store.category == category).toList();
}

/// 인기 가게 (평점 높은 순)
List<Store> getPopularStores({int limit = 5}) {
  final sorted = List<Store>.from(stores);
  sorted.sort((a, b) => b.rating.compareTo(a.rating));
  return sorted.take(limit).toList();
}

/// 가까운 가게 (거리순)
List<Store> getNearbyStores({int limit = 5}) {
  final sorted = List<Store>.from(stores);
  sorted.sort((a, b) {
    final distA =
        int.tryParse(a.distance.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final distB =
        int.tryParse(b.distance.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return distA.compareTo(distB);
  });
  return sorted.take(limit).toList();
}
