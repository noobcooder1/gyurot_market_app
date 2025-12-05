import '../models/product.dart';

class Repository {
  static final Repository _instance = Repository._internal();

  factory Repository() {
    return _instance;
  }

  Repository._internal();

  // Products
  List<Product> products = [
    Product(
      id: 'prod_001',
      userId: 'user_002',
      sellerName: '판매자',
      title: '니콘 D5300 렌즈포함',
      location: '서울시 강남구 역삼동',
      price: '300,000원',
      imageUrl: 'https://picsum.photos/200',
      time: '2시간 전',
      likes: 3,
      category: '디지털기기',
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

  // Chat Messages
  Map<String, List<Map<String, dynamic>>> chatMessages = {
    'user_0': [
      {'isMe': false, 'text': '안녕하세요! 물건 아직 있나요?', 'time': '오후 2:00'},
      {'isMe': true, 'text': '네, 아직 있습니다!', 'time': '오후 2:05'},
    ],
  };

  void addMessage(String userId, String text) {
    if (!chatMessages.containsKey(userId)) {
      chatMessages[userId] = [];
    }
    chatMessages[userId]!.add({'isMe': true, 'text': text, 'time': '방금'});
  }

  List<Map<String, dynamic>> getMessages(String userId) {
    return chatMessages[userId] ?? [];
  }

  // Recent Searches
  List<String> recentSearches = [];
}
