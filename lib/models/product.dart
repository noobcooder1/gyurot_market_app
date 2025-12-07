import 'dart:typed_data';

class Product {
  final String id;
  final String userId;
  final String sellerName;
  final String title;
  final String location;
  final String price;
  final String imageUrl;
  final String time;
  final int likes;
  final String? category;
  final String? description;
  final List<Uint8List>? images; // 첨부 이미지 바이트 데이터
  final List<String>? imageUrls; // 네트워크 이미지 URL 리스트
  bool isFavorite;

  Product({
    required this.id,
    required this.userId,
    required this.sellerName,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.time,
    required this.likes,
    this.category,
    this.description,
    this.images,
    this.imageUrls,
    this.isFavorite = false,
  });
}

// 현재 로그인한 사용자 ID (더미)
const String currentUserId = 'user_001';

// Dummy Data - 다양한 카테고리의 상품들
List<Product> productList = [
  // 디지털기기 (4개)
  Product(
    id: 'prod_001',
    userId: 'user_002',
    sellerName: '판매자',
    title: '니콘 D5300 렌즈포함',
    location: '서울시 강남구 역삼동',
    price: '300,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400',
    time: '2시간 전',
    likes: 3,
    category: '디지털기기',
    description: '상품 상태가 좋습니다.\n직거래 환영합니다.\n가격 네고 가능합니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800',
      'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=800',
      'https://images.unsplash.com/photo-1617005082133-548c4dd27f35?w=800',
    ],
  ),
  Product(
    id: 'prod_002',
    userId: 'user_003',
    sellerName: '김철수',
    title: '아이폰 12 프로',
    location: '서울시 서초구 반포동',
    price: '750,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
    time: '4시간 전',
    likes: 12,
    category: '디지털기기',
    description: '배터리 효율 85%입니다.\n액정 깨끗하고 기스 없습니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800',
      'https://images.unsplash.com/photo-1605236453806-6ff36851218e?w=800',
      'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?w=800',
    ],
  ),
  Product(
    id: 'prod_004',
    userId: 'user_004',
    sellerName: '이영희',
    title: '맥북 에어 M1',
    location: '서울시 관악구 신림동',
    price: '800,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=400',
    time: '3일 전',
    likes: 20,
    category: '디지털기기',
    description: '2021년 구입, 배터리 사이클 50회 미만입니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=800',
      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800',
      'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800',
    ],
  ),
  Product(
    id: 'prod_010',
    userId: 'user_010',
    sellerName: '정수민',
    title: '에어팟 프로 2세대',
    location: '서울시 강남구 삼성동',
    price: '180,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=400',
    time: '1시간 전',
    likes: 8,
    category: '디지털기기',
    description: '미개봉 새상품입니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=800',
      'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=800',
    ],
  ),

  // 스포츠/레저 (3개)
  Product(
    id: 'prod_003',
    userId: 'user_001',
    sellerName: '당근이',
    title: '자전거 팝니다',
    location: '서울시 송파구 잠실동',
    price: '100,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=400',
    time: '1일 전',
    likes: 5,
    category: '스포츠/레저',
    description: '생활기스 있으나 사용에 문제 없습니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=800',
      'https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=800',
    ],
  ),
  Product(
    id: 'prod_011',
    userId: 'user_011',
    sellerName: '이운동',
    title: '요가매트 + 폼롤러 세트',
    location: '서울시 마포구 합정동',
    price: '25,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=400',
    time: '5시간 전',
    likes: 4,
    category: '스포츠/레저',
    description: '몇 번 사용하지 않았습니다. 깨끗해요.',
    imageUrls: [
      'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=800',
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
    ],
  ),
  Product(
    id: 'prod_012',
    userId: 'user_012',
    sellerName: '박헬스',
    title: '덤벨 10kg 2개',
    location: '서울시 용산구 이태원동',
    price: '35,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400',
    time: '2일 전',
    likes: 7,
    category: '스포츠/레저',
    description: '홈트레이닝용 덤벨입니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
      'https://images.unsplash.com/photo-1581009146145-b5ef050c149a?w=800',
    ],
  ),

  // 가구/인테리어 (3개)
  Product(
    id: 'prod_005',
    userId: 'user_005',
    sellerName: '박민수',
    title: '게이밍 의자',
    location: '서울시 동작구 사당동',
    price: '50,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1598550476439-6847785fcea6?w=400',
    time: '5일 전',
    likes: 1,
    category: '가구/인테리어',
    description: '1년 사용했습니다. 쿠션 상태 양호.',
    imageUrls: [
      'https://images.unsplash.com/photo-1598550476439-6847785fcea6?w=800',
      'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=800',
    ],
  ),
  Product(
    id: 'prod_013',
    userId: 'user_013',
    sellerName: '김인테리어',
    title: '이케아 책상',
    location: '서울시 강서구 화곡동',
    price: '45,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=400',
    time: '3일 전',
    likes: 6,
    category: '가구/인테리어',
    description: '이사로 인해 판매합니다. 직거래만 가능.',
    imageUrls: [
      'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=800',
      'https://images.unsplash.com/photo-1593062096033-9a26b09da705?w=800',
    ],
  ),
  Product(
    id: 'prod_014',
    userId: 'user_014',
    sellerName: '박가구',
    title: '스탠드 조명',
    location: '서울시 성북구 길음동',
    price: '20,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=400',
    time: '4일 전',
    likes: 2,
    category: '가구/인테리어',
    description: 'LED 조명, 밝기 조절 가능합니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800',
      'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?w=800',
    ],
  ),

  // 생활가전 (2개)
  Product(
    id: 'prod_006',
    userId: 'user_006',
    sellerName: '최가전',
    title: '다이슨 청소기',
    location: '서울시 노원구 상계동',
    price: '280,000원',
    imageUrl: 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=400',
    time: '1주 전',
    likes: 15,
    category: '생활가전',
    description: 'V10 모델, 필터 새것으로 교체했습니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=800',
      'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?w=800',
    ],
  ),
  Product(
    id: 'prod_015',
    userId: 'user_015',
    sellerName: '이전자',
    title: '전자레인지',
    location: '서울시 중랑구 면목동',
    price: '30,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1574269909862-7e1d70bb8078?w=400',
    time: '6일 전',
    likes: 3,
    category: '생활가전',
    description: '삼성 전자레인지, 정상 작동합니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1574269909862-7e1d70bb8078?w=800',
    ],
  ),

  // 여성의류 (2개)
  Product(
    id: 'prod_007',
    userId: 'user_007',
    sellerName: '김패션',
    title: '자라 코트 S사이즈',
    location: '서울시 종로구 혜화동',
    price: '70,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=400',
    time: '2일 전',
    likes: 9,
    category: '여성의류',
    description: '한 번 착용했습니다. 새것과 다름없어요.',
    imageUrls: [
      'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800',
      'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=800',
    ],
  ),
  Product(
    id: 'prod_016',
    userId: 'user_016',
    sellerName: '박의류',
    title: '나이키 운동복 세트',
    location: '서울시 광진구 건대입구',
    price: '40,000원',
    imageUrl:
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400',
    time: '3시간 전',
    likes: 5,
    category: '여성의류',
    description: 'M사이즈, 상하의 세트입니다.',
    imageUrls: [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800',
      'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=800',
    ],
  ),

  // 도서/티켓/음반 (1개)
  Product(
    id: 'prod_008',
    userId: 'user_008',
    sellerName: '책벌레',
    title: '해리포터 전집 (1-7권)',
    location: '서울시 광진구 자양동',
    price: '60,000원',
    imageUrl: 'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?w=400',
    time: '4일 전',
    likes: 11,
    category: '도서/티켓/음반',
    description: '상태 아주 좋습니다. 7권 모두 포함.',
    imageUrls: [
      'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?w=800',
      'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=800',
      'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=800',
    ],
  ),
];

// 최근 본 상품 목록
List<Product> recentlyViewedProducts = [];

// 관심 목록
List<Product> favoriteProducts = [];
