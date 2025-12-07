import 'package:flutter/material.dart';
import 'dart:typed_data';

/// 가게 데이터 모델
class Store {
  final String id;
  final String name;
  final String category;
  final String description;
  final String address;
  final String distance;
  double rating; // mutable로 변경
  int reviewCount;
  final String phoneNumber;
  final String openingHours;
  final List<String> images;
  final List<MenuItem> menu;
  List<Review> reviews;

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
    List<Review>? reviews,
  }) : reviews = reviews ?? [];

  // reviewCount를 실제 리뷰 수와 동기화
  void syncReviewCount() {
    reviewCount = reviews.length;
  }

  // 리뷰 기반 평균 별점 계산 및 업데이트
  void updateAverageRating() {
    if (reviews.isEmpty) return;

    double totalRating = 0;
    for (final review in reviews) {
      totalRating += review.rating;
    }
    rating = double.parse((totalRating / reviews.length).toStringAsFixed(1));
  }
}

/// 메뉴 아이템
class MenuItem {
  final String name;
  final String price;
  final String? description;
  final bool isPopular;

  MenuItem({
    required this.name,
    required this.price,
    this.description,
    this.isPopular = false,
  });
}

/// 리뷰
class Review {
  final String authorName;
  final double rating;
  final String content;
  final DateTime createdAt;
  final List<Uint8List>? images; // 리뷰 사진

  Review({
    required this.authorName,
    required this.rating,
    required this.content,
    required this.createdAt,
    this.images,
  });

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}달 전';
    if (diff.inDays > 0) return '${diff.inDays}일 전';
    if (diff.inHours > 0) return '${diff.inHours}시간 전';
    return '방금 전';
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

// 리뷰 생성 헬퍼 함수
List<Review> _generateReviews(
  int count,
  List<String> names,
  List<String> contents,
) {
  final reviews = <Review>[];
  for (int i = 0; i < count && i < names.length && i < contents.length; i++) {
    reviews.add(
      Review(
        authorName: names[i],
        rating: 4.0 + (i % 3) * 0.5,
        content: contents[i],
        createdAt: DateTime.now().subtract(Duration(days: i + 1)),
      ),
    );
  }
  return reviews;
}

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
    reviewCount: 5,
    phoneNumber: '010-1234-5678',
    openingHours: '10:00 - 22:00',
    menu: [
      MenuItem(
        name: '떡볶이',
        price: '4,000원',
        description: '매콤달콤',
        isPopular: true,
      ),
      MenuItem(name: '순대', price: '4,000원'),
      MenuItem(name: '튀김모듬', price: '5,000원', isPopular: true),
      MenuItem(name: '라볶이', price: '5,500원'),
      MenuItem(name: '김밥', price: '3,500원'),
      MenuItem(name: '오뎅', price: '3,000원'),
      MenuItem(name: '쫄면', price: '5,000원'),
      MenuItem(name: '비빔밥', price: '6,000원'),
    ],
    reviews: _generateReviews(
      5,
      ['맛집탐방', '순대러버', '김맛집', '이분식', '박맛나'],
      ['떡볶이 진짜 맛있어요!', '순대도 추천합니다', '자주 이용합니다', '가성비 좋아요', '양도 많고 맛있어요'],
    ),
  ),
  Store(
    id: 'store_002',
    name: '할매순대국',
    category: '맛집',
    description: '40년 전통 순대국 전문점',
    address: '아라동 456-78',
    distance: '500m',
    rating: 4.7,
    reviewCount: 4,
    phoneNumber: '010-2345-6789',
    openingHours: '06:00 - 21:00',
    menu: [
      MenuItem(name: '순대국', price: '8,000원', isPopular: true),
      MenuItem(name: '내장탕', price: '9,000원'),
      MenuItem(name: '모듬수육', price: '25,000원', isPopular: true),
      MenuItem(name: '순대국밥(대)', price: '10,000원'),
      MenuItem(name: '뚝배기순대국', price: '9,000원'),
      MenuItem(name: '수육국밥', price: '9,500원'),
    ],
    reviews: _generateReviews(
      4,
      ['국밥매니아', '아침식사', '순대킹', '맛집탐방가'],
      ['역시 전통의 맛!', '해장하기 딱 좋아요', '고기가 푸짐해요', '가격대비 최고'],
    ),
  ),
  Store(
    id: 'store_003',
    name: '청년피자',
    category: '맛집',
    description: '화덕에서 구운 수제 피자',
    address: '아라동 789-12',
    distance: '800m',
    rating: 4.6,
    reviewCount: 3,
    phoneNumber: '010-3456-7890',
    openingHours: '11:00 - 22:00',
    menu: [
      MenuItem(name: '마르게리따', price: '15,000원', isPopular: true),
      MenuItem(name: '페퍼로니', price: '17,000원', isPopular: true),
      MenuItem(name: '고르곤졸라', price: '18,000원'),
      MenuItem(name: '불고기피자', price: '19,000원'),
      MenuItem(name: '하와이안', price: '17,000원'),
      MenuItem(name: '콤비네이션', price: '20,000원'),
      MenuItem(name: '파스타', price: '13,000원'),
      MenuItem(name: '샐러드', price: '8,000원'),
    ],
    reviews: _generateReviews(
      3,
      ['피자러버', '화덕맛집', '이탈리안'],
      ['화덕피자 정말 맛있어요', '도우가 쫄깃해요', '토핑이 신선해요'],
    ),
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
    reviewCount: 5,
    phoneNumber: '010-4567-8901',
    openingHours: '09:00 - 22:00',
    menu: [
      MenuItem(name: '아메리카노', price: '4,500원', isPopular: true),
      MenuItem(name: '카페라떼', price: '5,000원', isPopular: true),
      MenuItem(name: '티라미수', price: '6,500원'),
      MenuItem(name: '아이스 아메리카노', price: '4,500원'),
      MenuItem(name: '바닐라 라떼', price: '5,500원'),
      MenuItem(name: '카푸치노', price: '5,000원'),
      MenuItem(name: '생크림 케이크', price: '6,000원'),
      MenuItem(name: '치즈케이크', price: '6,500원'),
      MenuItem(name: '마카롱 세트', price: '8,000원'),
      MenuItem(name: '아인슈페너', price: '5,500원'),
    ],
    reviews: _generateReviews(
      5,
      ['커피매니아', '카페투어', '디저트킹', '공부왕', '카페스타'],
      ['분위기 좋아요!', '커피 맛있습니다', '케이크도 추천해요', '공부하기 좋아요', '직원분들이 친절해요'],
    ),
  ),
  Store(
    id: 'store_005',
    name: '스터디카페 집중',
    category: '카페',
    description: '조용한 분위기의 스터디 카페',
    address: '아라동 567-89',
    distance: '600m',
    rating: 4.3,
    reviewCount: 3,
    phoneNumber: '010-5678-9012',
    openingHours: '24시간',
    menu: [
      MenuItem(name: '1시간 이용권', price: '2,000원'),
      MenuItem(name: '3시간 이용권', price: '5,000원', isPopular: true),
      MenuItem(name: '종일권', price: '12,000원', isPopular: true),
      MenuItem(name: '정기권(1개월)', price: '150,000원'),
      MenuItem(name: '아메리카노', price: '2,500원'),
      MenuItem(name: '라떼', price: '3,000원'),
    ],
    reviews: _generateReviews(
      3,
      ['공시생', '대학생', '취준생'],
      ['24시간이라 좋아요', '조용해서 집중 잘 돼요', '시설이 깔끔해요'],
    ),
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
    reviewCount: 4,
    phoneNumber: '010-6789-0123',
    openingHours: '09:00 - 21:00',
    menu: [
      MenuItem(name: '처방전 조제', price: '처방전 필요'),
      MenuItem(name: '건강상담', price: '무료'),
      MenuItem(name: '영양제 상담', price: '무료'),
      MenuItem(name: '혈압/혈당 측정', price: '무료'),
    ],
    reviews: _generateReviews(
      4,
      ['건강맘', '약사님감사', '동네주민', '어르신'],
      ['친절하게 설명해주세요', '조제가 빨라요', '약사님이 친절해요', '항상 이용합니다'],
    ),
  ),
  Store(
    id: 'store_007',
    name: '24시 올나이트약국',
    category: '약국',
    description: '24시간 운영 약국',
    address: '아라동 333-44',
    distance: '450m',
    rating: 4.7,
    reviewCount: 3,
    phoneNumber: '010-7890-1234',
    openingHours: '24시간',
    menu: [
      MenuItem(name: '처방전 조제', price: '처방전 필요'),
      MenuItem(name: '응급약품', price: '문의'),
      MenuItem(name: '건강상담', price: '무료'),
    ],
    reviews: _generateReviews(
      3,
      ['야근맨', '응급상황', '밤샘족'],
      ['새벽에도 열어서 좋아요', '급할 때 찾게 돼요', '24시간 운영 감사해요'],
    ),
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
    reviewCount: 2,
    phoneNumber: '010-8901-2345',
    openingHours: '24시간',
    menu: [
      MenuItem(name: '도시락', price: '4,000원~'),
      MenuItem(name: '삼각김밥', price: '1,500원~'),
      MenuItem(name: '음료', price: '1,500원~'),
      MenuItem(name: '과자/스낵', price: '1,000원~'),
    ],
    reviews: _generateReviews(
      2,
      ['야식파', '편의점마니아'],
      ['가까워서 자주 가요', '직원분이 친절해요'],
    ),
  ),
  Store(
    id: 'store_009',
    name: 'GS25 아라중앙점',
    category: '편의점',
    description: '24시간 편의점',
    address: '아라동 444-55',
    distance: '250m',
    rating: 4.1,
    reviewCount: 2,
    phoneNumber: '010-9012-3456',
    openingHours: '24시간',
    menu: [
      MenuItem(name: '도시락', price: '4,000원~'),
      MenuItem(name: '샌드위치', price: '3,000원~'),
      MenuItem(name: '음료', price: '1,500원~'),
      MenuItem(name: '아이스크림', price: '1,500원~'),
    ],
    reviews: _generateReviews(2, ['새벽족', '도시락러버'], ['깔끔해요', '신상 도시락이 맛있어요']),
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
    reviewCount: 4,
    phoneNumber: '010-0123-4567',
    openingHours: '09:00 - 18:00',
    menu: [
      MenuItem(name: '일반진료', price: '건강보험 적용'),
      MenuItem(name: '건강검진', price: '문의'),
      MenuItem(name: '독감예방접종', price: '35,000원'),
      MenuItem(name: '코로나 검사', price: '문의'),
    ],
    reviews: _generateReviews(
      4,
      ['환자1', '건강검진', '감기환자', '동네주민'],
      ['의사선생님이 친절해요', '대기시간이 짧아요', '설명을 잘 해주세요', '항상 이 병원만 가요'],
    ),
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
    reviewCount: 3,
    phoneNumber: '010-1234-5678',
    openingHours: '06:00 - 24:00',
    menu: [
      MenuItem(name: '1개월 이용권', price: '70,000원'),
      MenuItem(name: '3개월 이용권', price: '180,000원', isPopular: true),
      MenuItem(name: '6개월 이용권', price: '300,000원', isPopular: true),
      MenuItem(name: 'PT 10회', price: '500,000원'),
      MenuItem(name: 'PT 20회', price: '900,000원'),
      MenuItem(name: '그룹 PT', price: '200,000원'),
    ],
    reviews: _generateReviews(
      3,
      ['운동왕', '헬스초보', '다이어터'],
      ['장비가 좋아요', '트레이너분들이 친절해요', '시설이 깨끗해요'],
    ),
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
    reviewCount: 3,
    phoneNumber: '010-2345-6789',
    openingHours: '14:00 - 22:00',
    menu: [
      MenuItem(name: '초등반', price: '150,000원/월'),
      MenuItem(name: '중등반', price: '180,000원/월', isPopular: true),
      MenuItem(name: '고등반', price: '200,000원/월'),
      MenuItem(name: '토익반', price: '250,000원/월'),
      MenuItem(name: '회화반', price: '200,000원/월'),
    ],
    reviews: _generateReviews(
      3,
      ['학부모1', '학부모2', '성인학생'],
      ['아이가 재미있게 다녀요', '선생님들이 열정적이에요', '영어 실력이 늘었어요'],
    ),
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
    reviewCount: 4,
    phoneNumber: '010-3456-7890',
    openingHours: '10:00 - 20:00',
    menu: [
      MenuItem(name: '커트', price: '15,000원', isPopular: true),
      MenuItem(name: '염색', price: '50,000원~'),
      MenuItem(name: '펌', price: '80,000원~', isPopular: true),
      MenuItem(name: '클리닉', price: '30,000원~'),
      MenuItem(name: '드라이', price: '10,000원'),
      MenuItem(name: '두피케어', price: '40,000원'),
    ],
    reviews: _generateReviews(
      4,
      ['뷰티러버', '스타일리시', '단골손님', '첫방문'],
      ['머리 예쁘게 해주셔요', '상담을 잘 해주세요', '10년 단골이에요', '분위기가 좋아요'],
    ),
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

/// 전체 인기 가게 (무제한)
List<Store> getAllPopularStores() {
  final sorted = List<Store>.from(stores);
  sorted.sort((a, b) => b.rating.compareTo(a.rating));
  return sorted;
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

/// 가게에 리뷰 추가
void addReviewToStore(String storeId, Review review) {
  final storeIndex = stores.indexWhere((s) => s.id == storeId);
  if (storeIndex != -1) {
    stores[storeIndex].reviews.insert(0, review);
    stores[storeIndex].reviewCount = stores[storeIndex].reviews.length;
    stores[storeIndex].updateAverageRating(); // 평균 별점 업데이트
  }
}
