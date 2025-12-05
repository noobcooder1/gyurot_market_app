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
    this.isFavorite = false,
  });
}

// 현재 로그인한 사용자 ID (더미)
const String currentUserId = 'user_001';

// Dummy Data
List<Product> productList = [
  Product(
    id: 'prod_001',
    userId: 'user_002', // 다른 사용자
    sellerName: '판매자',
    title: '니콘 D5300 렌즈포함',
    location: '서울시 강남구 역삼동',
    price: '300,000원',
    imageUrl: 'https://picsum.photos/200',
    time: '2시간 전',
    likes: 3,
    category: '디지털기기',
    description: '상품 상태가 좋습니다.\n직거래 환영합니다.\n가격 네고 가능합니다.',
  ),
  Product(
    id: 'prod_002',
    userId: 'user_003',
    sellerName: '김철수',
    title: '아이폰 12 프로',
    location: '서울시 서초구 반포동',
    price: '750,000원',
    imageUrl: 'https://picsum.photos/201',
    time: '4시간 전',
    likes: 12,
    category: '디지털기기',
  ),
  Product(
    id: 'prod_003',
    userId: 'user_001', // 내 게시글
    sellerName: '당근이',
    title: '자전거 팝니다',
    location: '서울시 송파구 잠실동',
    price: '100,000원',
    imageUrl: 'https://picsum.photos/202',
    time: '1일 전',
    likes: 5,
    category: '스포츠/레저',
  ),
  Product(
    id: 'prod_004',
    userId: 'user_004',
    sellerName: '이영희',
    title: '맥북 에어 M1',
    location: '서울시 관악구 신림동',
    price: '800,000원',
    imageUrl: 'https://picsum.photos/203',
    time: '3일 전',
    likes: 20,
    category: '디지털기기',
  ),
  Product(
    id: 'prod_005',
    userId: 'user_005',
    sellerName: '박민수',
    title: '게이밍 의자',
    location: '서울시 동작구 사당동',
    price: '50,000원',
    imageUrl: 'https://picsum.photos/204',
    time: '5일 전',
    likes: 1,
    category: '가구/인테리어',
  ),
];

// 최근 본 상품 목록
List<Product> recentlyViewedProducts = [];

// 관심 목록
List<Product> favoriteProducts = [];
